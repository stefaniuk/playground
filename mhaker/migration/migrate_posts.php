#!/usr/bin/env php
<?php

// ./migrate_posts.php 2>&1 | tee migrate_posts.out

define('ENVIRONMENT', 'production');

require_once('./zendframework/library/Zend/Debug.php');

define('IN_PHPBB', true);
//$phpbb_root_path = getcwd() . '/sites/mhaker.pl/phpBB3/';
$phpbb_root_path = getcwd() . '/phpBB3/';
$phpEx = substr(strrchr(__FILE__, '.'), 1);
include($phpbb_root_path . 'common.' . $phpEx);
include($phpbb_root_path . 'includes/functions_posting.' . $phpEx);
include($phpbb_root_path . 'includes/message_parser.' . $phpEx);

function my_get_db_connection() {

    $conn = mysql_connect('localhost', 'root', DB_PASSWORD) or die('Could not connect: ' . mysql_error());
    mysql_query("SET CHARACTER SET 'utf8';", $conn);
    mysql_query("SET NAMES 'utf8';", $conn);

    return $conn;
}
function my_populate_posts() {

    global $user;

    $conn = my_get_db_connection();

	mysql_query("delete from mhaker_forum.topics_posted");
    mysql_query("delete from mhaker_forum.topics");
    mysql_query("delete from mhaker_forum.posts");

    $sql = "
        select
            u.user_name as 'user_name',
            m.id as 'old_post_id',
            t.id as 'old_topic_id',
            f.id as 'old_forum_id',
            fp.forum_id as 'new_forum_id',
            unix_timestamp(m.time) as 'time',
            t.name as 'subject',
            m.message as 'content',
            (select case m.new_topic when 0 then 'reply' when 1 then 'post' end) as 'post_type'
        from
            mhaker.mhaker_users u,
            mhaker.mhaker_forum_messages m,
            mhaker.mhaker_forum_topics t,
            mhaker.mhaker_forum_forums f,
            mhaker_forum.forums fp
        where
            u.user_name = m.user and
            m.topic = t.id and
            t.forum = f.id and
            f.name =  fp.forum_name and
            fp.forum_type = 1
        order by
            f.id, t.id, m.id
    ";
    $result = mysql_query($sql);
    $count = 1;
    $post_data = NULL;
    while ($data = mysql_fetch_array($result, MYSQL_ASSOC)) {

        echo "($count) posted by '${data['user_name']}' '${data['subject']}' '${data['post_type']}'\n";
        ++$count;

        // TODO: remove it >>>>>>>>>>>>>>>>>>>>
        /*if($count > 10) {
            break;
        }*/
        // TODO: remove it <<<<<<<<<<<<<<<<<<<<

        // utwórz globalny obiekt użytkownika
        $user_result = mysql_query("select * from mhaker_forum.users where username = '${data['user_name']}'");
        $user_data = mysql_fetch_array($user_result, MYSQL_ASSOC);
        $user = new user();
        $user->data = $user_data;

        $poll = $uid = $bitfield = $options = '';
        generate_text_for_storage($data['subject'], $uid, $bitfield, $options, false, false, false);
        generate_text_for_storage($data['content'], $uid, $bitfield, $options, true, true, true);

        $post = array(
            'forum_id'          	=> $data['new_forum_id'],
            'topic_id'          	=> ($data['post_type'] == 'reply' ? $post_data['topic_id'] : NULL),
            'icon_id'           	=> false,
            'enable_bbcode'     	=> true,
            'enable_smilies'    	=> true,
            'enable_urls'       	=> true,
            'enable_sig'        	=> true,
            'message'           	=> $data['content'],
            'message_md5'       	=> md5($data['content']),
            'bbcode_bitfield'   	=> $bitfield,
            'bbcode_uid'        	=> $uid,
            'post_edit_locked'  	=> 0,
            'topic_title'       	=> $data['subject'],
            'notify_set'        	=> false,
            'notify'            	=> false,
            'post_time'         	=> $data['time'],
			'force_approved_state'	=> 1,
            'forum_name'        	=> '',
            'enable_indexing'   	=> true
        );
        Zend_Debug::dump($post);
        submit_post($data['post_type'], $data['subject'], $data['user_name'], POST_NORMAL, $poll, $post);

        // zapmiętaj pierwszy post w temacie
        if($data['post_type'] == 'post') {
            $post_result = mysql_query("select * from mhaker_forum.posts order by post_id desc limit 0, 1");
            $post_data = mysql_fetch_array($post_result, MYSQL_ASSOC);
            mysql_free_result($post_result);
        }
    }
	mysql_free_result($result);

	mysql_query("update mhaker_forum.topics set topic_approved = 1");
	mysql_query("update mhaker_forum.posts set post_approved = 1");

    mysql_close($conn);
}

define('DB_PASSWORD', $argv[1]);
my_populate_posts();
variable_set('phpbbforum_root', '/srv/hosting/domains/mhaker.pl/usr/local/drupal/phpBB3/');
