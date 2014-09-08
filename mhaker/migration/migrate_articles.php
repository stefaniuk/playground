#!/usr/bin/env php
<?php

// ./migrate_articles.php 2>&1 | tee migrate_articles.out

//define('ENVIRONMENT', 'production');

require_once('./zendframework/library/Zend/Debug.php');
define('DRUPAL_ROOT', getcwd());
require_once('./includes/bootstrap.inc');
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);
require_once('./sites/all/modules/contrib/profile2/profile2.module');

function my_get_db_connection() {

    $conn = mysql_connect('localhost', 'root', DB_PASSWORD) or die('Could not connect: ' . mysql_error());
    mysql_query("SET CHARACTER SET 'utf8';", $conn);
    mysql_query("SET NAMES 'utf8';", $conn);

    return $conn;
}
function my_populate_articles() {

    global $user;

    $conn = my_get_db_connection();

    mysql_query("delete from mhaker_cms_dev.url_alias where alias like 'article/%'");
	mysql_query("delete from mhaker_cms_dev.field_data_body");
	mysql_query("delete from mhaker_cms_dev.field_revision_body");
    mysql_query("delete from mhaker_cms_dev.node");
	mysql_query("delete from mhaker_cms_dev.node_revision");
	mysql_query("delete from mhaker_cms_dev.node_comment_statistics");

    $sql = "
        select
            uo.user_name as user,
            un.uid as id,
            unix_timestamp(p.time) as 'time_created',
            p.*
        from
            mhaker.mhaker_users uo,
            mhaker.mhaker_page p,
            mhaker_cms.users un
        where
            uo.user_id = p.uid and
            uo.user_name = un.name
        order by
            p.time
    ";
    $result = mysql_query($sql);
    $count = 1;
    $post_data = NULL;
    while ($data = mysql_fetch_array($result, MYSQL_ASSOC)) {

        echo "($count) '${data['user']}' '${data['id']}' '${data['time']}' '${data['title']}'\n";

        $text = $data['hometext'] . (strlen($data['hometext']) > 0 && strlen($data['bodytext']) > 0 ? '<br /><br />' : '') . $data['bodytext'];

        $node = new stdClass();
        $node->type = 'article';
        node_object_prepare($node);

        $node->uid = $data['id'];
        $node->created = $data['time_created'];
        $node->changed = $data['time_created'];
        $node->title = $data['title'];
        $node->language = LANGUAGE_NONE;
        $node->body[$node->language][0]['value'] = $text;
        $node->body[$node->language][0]['summary'] = text_summary($text);
        $node->body[$node->language][0]['format'] = 'full_html';
        $node->path = array('alias' => 'article/' . $count);

        node_save($node);
        //Zend_Debug::dump($node);

        ++$count;
    }
	mysql_free_result($result);

    mysql_close($conn);
}

define('DB_PASSWORD', $argv[1]);
my_populate_articles();
