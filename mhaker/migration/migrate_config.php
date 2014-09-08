#!/usr/bin/env php
<?php
/*

./migrate_config.php 0 2>&1 | tee migrate_config.out

*/

define('ENVIRONMENT', 'production');

require_once('./zendframework/library/Zend/Debug.php');
define('DRUPAL_ROOT', getcwd());
require_once('./includes/bootstrap.inc');
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);
require_once('./sites/all/modules/contrib/profile2/profile2.module');
require_once('./modules/field/field.module');

function my_get_db_connection() {

    $conn = mysql_connect('localhost', 'root', DB_PASSWORD) or die('Could not connect: ' . mysql_error());
    mysql_query("SET CHARACTER SET 'utf8';", $conn);
    mysql_query("SET NAMES 'utf8';", $conn);

    return $conn;
}
function my_create_roles() {

    $conn = my_get_db_connection();
    mysql_query("delete from mhaker_cms.role where rid > 3");

    $roles = array('moderator', 'moderator globalny');
    foreach ($roles as $r){
        if (!user_role_load_by_name($r)) {
            $role = new stdClass();
            $role->name = $r;
            user_role_save($role);
        }
    }

    mysql_query("update mhaker_cms.role set weight=0 where name='użytkownik anonimowy'");
    mysql_query("update mhaker_cms.role set weight=1 where name='użytkownik uwierzytelniony'");
    mysql_query("update mhaker_cms.role set weight=2 where name='moderator'");
    mysql_query("update mhaker_cms.role set weight=3 where name='moderator globalny'");
    mysql_query("update mhaker_cms.role set weight=4 where name='administrator'");

    mysql_close($conn);
}

function my_insert_permissions($rid, $permissions, $module) {

    $conn = my_get_db_connection();

    mysql_query("delete from mhaker_cms.role_permission where rid=$rid and module='$module'");
    foreach ($permissions as $permission) {
        mysql_query("insert into mhaker_cms.role_permission (rid, permission, module) values ($rid, '$permission', '$module')");
    }

    mysql_close($conn);
}

function my_set_permissions($profile_name) {

    /*
        1 - użytkownik anonimowy
        2 - użytkownik uwierzytelniony
        4 - moderator
        5 - moderator globalny
        3 - administrator
    */

    // profile
    $arr = array(2, 4, 5);
    foreach ($arr as $value) {
        my_insert_permissions($value, array(
            "view own ${profile_name} profile",
            "edit own ${profile_name} profile",
            "view any ${profile_name} profile"
        ), 'profile2');
    }
    // userpoints
    my_insert_permissions(1, array(
        'view userpoints'
    ), 'userpoints');
    $arr = array(2, 4, 5);
    foreach ($arr as $value) {
        my_insert_permissions($value, array(
            'view userpoints',
            'view own userpoints'
        ), 'userpoints');
    }
    // phpbbforum
    my_insert_permissions(1, array(
        'access phpBB forum',
        'access phpBB comments'
    ), 'phpbbforum');
    $arr = array(2, 4, 5);
    foreach ($arr as $value) {
        my_insert_permissions($value, array(
            'access phpBB forum',
            'access phpBB comments',
            'create phpBB forum topics',
            'post phpBB comments'
        ), 'phpbbforum');
    }
}

define('DB_PASSWORD', $argv[1]);
$profile_name = 'profile';
my_create_roles();
my_set_permissions($profile_name);
