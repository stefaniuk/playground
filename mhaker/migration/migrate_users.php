#!/usr/bin/env php
<?php
/*

./migrate_users.php 0 2>&1 | tee migrate_users_0.out
sleep 10
./migrate_users.php 1 2>&1 | tee migrate_users_1.out
sleep 10
./migrate_users.php 2 2>&1 | tee migrate_users_2.out
sleep 10
./migrate_users.php 3 2>&1 | tee migrate_users_3.out
sleep 10
./migrate_users.php 4 2>&1 | tee migrate_users_4.out

*/

define('ENVIRONMENT', 'production');

require_once('./zendframework/library/Zend/Debug.php');
define('DRUPAL_ROOT', getcwd());
require_once('./includes/bootstrap.inc');
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);
require_once('./sites/all/modules/contrib/profile2/profile2.module');
require_once('./modules/field/field.module');

variable_set('phpbbforum_root', './phpBB3/');
define('IN_PHPBB', true);
$phpbb_root_path = DRUPAL_ROOT . '/phpBB3/';
$phpEx = substr(strrchr(__FILE__, '.'), 1);

function my_get_db_connection() {

    $conn = mysql_connect('localhost', 'root', DB_PASSWORD) or die('Could not connect: ' . mysql_error());
    mysql_query("SET CHARACTER SET 'utf8';", $conn);
    mysql_query("SET NAMES 'utf8';", $conn);

    return $conn;
}
function my_create_profile($type, $label) {

    $conn = my_get_db_connection();
    mysql_select_db('mhaker_cms', $conn);
    mysql_query("delete from field_config_instance where bundle='$type'");
    mysql_query("delete from profile_type where type='$type'");
    mysql_query("delete from profile where type='$type'");
    mysql_query("delete from profile_type where type='main'");
    mysql_close($conn);

    echo "profil użytkownika '${type}', '${label}'\n";

    profile2_type_save(new ProfileType(array(
        'type' => $type,
        'label' => $label,
        'status' => 1,
        'data' => array(
            'registration' => true,
            'use_page' => true
        )
    )));
}
function my_delete_field($name) {

    $conn = my_get_db_connection();
    mysql_select_db('mhaker_cms', $conn);
    mysql_query("delete from field_config_instance where field_name='${name}'");
    mysql_query("delete from field_config where field_name='${name}'");
    mysql_query("drop table field_data_${name}");
    mysql_query("drop table field_revision_${name}");
    mysql_close($conn);
}
function my_create_field_text($name, $label, $description, $max_length, $bundle) {

    my_delete_field($name);

    echo "pole tekstowe profilu '${name}', '${label}'\n";

    field_create_field(array(
        'field_name' => $name,
        'type' => 'text',
        'settings' => array(
            'max_length' => $max_length
        )
    ));
    field_create_instance(array(
        'field_name' => $name,
        'entity_type' => 'profile2',
        'bundle' => $bundle,
        'label' => t($label),
        'description' => t($description),
        'settings' => array(
            'text_processing' => 0
        ),
        'widget' => array(
            'type' => 'text_textfield'
        )
    ));
}
function my_create_field_select($name, $label, $description, $allowed_values, $default_value, $bundle) {

    my_delete_field($name);

    echo "pole wyboru profilu '${name}', '${label}'\n";

    field_create_field(array(
        'field_name' => $name,
        'type' => 'list_text',
        'settings' => array(
            'allowed_values' => $allowed_values
        )
    ));
    field_create_instance(array(
        'field_name' => $name,
        'entity_type' => 'profile2',
        'bundle' => $bundle,
        'label' => t($label),
        'description' => t($description),
        'settings' => array(
            'text_processing' => 0
        ),
        'default_value' => array($default_value),
        'widget' => array(
            'type' => 'list_default'
        )
    ));
}
function my_create_fields($bundle) {

    my_create_field_select('field_sex', 'Płeć', 'Płeć użytkownika', array('K' => 'Kobieta', 'M' => 'Mężczyzna'), NULL,  $bundle);
    //my_create_field('field_date_of_birth', '', '', 'profile2', $bundle);
    //my_create_field('field_date_of_registration', '', '', 'profile2', $bundle);
    my_create_field_text('field_home_page', 'Strona domowa', 'Adres URL strony domowej', 100, $bundle);
    // map<instant_messenger, instant_messenger_id>
    my_create_field_text('field_location', 'Lokalizacja', 'Miejsce zamieszkania', 100, $bundle);
    my_create_field_text('field_occupation', 'Zawód/zajęcie', 'Zawód lub zajęcie', 100, $bundle);
    my_create_field_text('field_hobby', 'Hobby', 'Hobby, pasja i zainteresowania', 255, $bundle);
    my_create_field_text('field_signature', 'Sygnatura', 'Tekst który zostanie dodany do twoich wypowiedzi', 255, $bundle);
    //my_create_field('field_warnings', 'Warnings', 'number_integer', 'profile2', $bundle);
    my_create_field_select('field_visible_email_address', 'Widoczny adres e-mail', 'Czy adres e-mail ma być widoczny dla wszystkich użytkowników?', array('T' => 'Tak', 'N' => 'Nie'), array('value' => 'N'), $bundle);
    my_create_field_select('field_neswletter', 'Otrzymój newsletter', 'Czy chcesz otrzymywać newsletter na twój adres e-mail?', array('T' => 'Tak', 'N' => 'Nie'), array('value' => 'T'), $bundle);
}
function my_populate_accounts($profile_name, $step) {

    $conn = my_get_db_connection();

	$n = 1000;

    mysql_select_db('mhaker');
	if($step == 0) {
		mysql_query("delete from mhaker_cms.users where uid > 1");
		mysql_query("delete from mhaker_forum.users where user_id > 53");
		mysql_query("update mhaker_forum.users set username = 'Anonim', username_clean = 'anonim' where user_id = 1");
		$result = mysql_query("select * from mhaker_users limit $n");
	}
	else {
		$l = $step * $n;
		$result = mysql_query("select * from mhaker_users limit $l,$n");
	}
    $count = $step * $n + 1;
    while ($data = mysql_fetch_array($result, MYSQL_ASSOC)) {

        echo "($count) użytkownik '${data['user_name']}' '${data['user_email']}'";
        ++$count;

        if(strtolower($data['user_name']) == 'anonim' /*|| strtolower($data['user_name']) == 'admin'*/) {
            continue;
        }

        // TODO: remove it >>>>>>>>>>>>>>>>>>>>
        /*if($count > 10) {
            break;
        }*/
        // TODO: remove it <<<<<<<<<<<<<<<<<<<<

        try {
            $v = user_save(NULL, array(
                'name' => $data['user_name'],
                'pass' => 'kisn7g2TAihboN8LzEU', // TODO: hasło użytkownika
                'mail' => strtolower($data['user_email']),
                'status' => 1,
                'language' => 'pl',
                'init' => strtolower($data['user_email']),
                'roles' => array(2 => 'authenticated user')
            ));
			//Zend_Debug::dump($v);
        }
        catch (Exception $e) {
            echo " (już istnieje)\n";
			Zend_Debug::dump($e);
            continue;
        }
        echo "\n";

        $profile = profile_create(array(
            'type' => $profile_name
        ));
        $user = user_load_by_name($data['user_name']);
        $profile->setUser($user);
        $profile->save();

        my_update_profile($data, $user);
    }
    mysql_free_result($result);

    mysql_close($conn);
}
function my_update_profile($data, $user) {

    $arr = profile2_load_by_user($user);
    $profile = $arr['profile'];
    $profile->field_sex['und'][0]['value'] = $data['user_gender'] == 1 ? 'M' : ($data['user_gender'] == 2 ? 'K' : NULL);
    $profile->field_home_page['und'][0]['value'] = !empty($data['user_website']) ? $data['user_website'] : NULL;
    $profile->field_location['und'][0]['value'] = !empty($data['user_from']) ? $data['user_from'] : NULL;
    $profile->field_occupation['und'][0]['value'] = !empty($data['user_occ']) ? $data['user_occ'] : NULL;
    $profile->field_hobby['und'][0]['value'] = !empty($data['user_interests']) ? $data['user_interests'] : NULL;
    $profile->field_visible_email_address['und'][0]['value'] = $data['user_viewemail'] == 1 ? 'T' : 'N';
    $profile->field_neswletter['und'][0]['value'] = $data['user_newsletter'] == 1 ? 'T' : 'N';
    profile2_save($profile);
}

define('DB_PASSWORD', $argv[1]);
$step = intval($argv[2]);
echo " *** START STEP $step ***\n";
$profile_name = 'profile';
if($step == 0) {
	my_create_profile($profile_name, 'Profil użytkownika');
	my_create_fields($profile_name);
}
my_populate_accounts($profile_name, $step);
echo " *** END STEP $step ***\n";
