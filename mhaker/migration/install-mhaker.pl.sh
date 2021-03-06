#!/bin/bash
#
#   install-mhaker.pl.sh 2>&1 | tee $HOST4GE_DIR/log/install-mhaker.pl.log

##
## checks
##

[ ! -f $HOST4GE_DIR/projects/mhaker.pl/database-phpbb3.tar.gz ] && echo "missing: $HOST4GE_DIR/projects/mhaker.pl/database-phpbb3.tar.gz" && exit 1

##
## includes
##

source $HOST4GE_DIR/sbin/include.sh

##
## variables
##

ACCOUNT_DIR="/srv/hosting/domains/mhaker.pl"
ACCOUNT_USER="mhaker.pl"

DOMAIN_OLD="mhaker.pl"
DOMAIN_NEW="nowy.mhaker.pl"
DOMAIN_DEV="dev.mhaker.pl"

# mhaker
MHAKER_DB_NAME="mhaker"
# cms
CMS_DB_NAME="mhaker_cms"
CMS_DB_USER=$CMS_DB_NAME
CMS_DB_PASS=`get_random_string 32`
CMS_DB_NAME_DEV="mhaker_cms_dev"
CMS_DB_USER_DEV=$CMS_DB_NAME_DEV
CMS_DB_PASS_DEV=`get_random_string 32`
# forum
FORUM_DB_NAME="mhaker_forum"
FORUM_DB_USER=$FORUM_DB_NAME
FORUM_DB_PASS=`get_random_string 32`
FORUM_DB_NAME_DEV="mhaker_forum_dev"
FORUM_DB_USER_DEV=$FORUM_DB_NAME_DEV
FORUM_DB_PASS_DEV=`get_random_string 32`

DB_ROOT_PASSWORD=`mysql_get_user_password root`
SCRIPT_WORKING_DIR=`pwd`

# drop database
mysql_drop_database $CMS_DB_NAME
mysql_drop_database $CMS_DB_NAME_DEV
mysql_drop_database $FORUM_DB_NAME
mysql_drop_database $FORUM_DB_NAME_DEV

# clear domain dirs
rm -r $ACCOUNT_DIR/usr/local/domains/{$DOMAIN_NEW,$DOMAIN_DEV}/*

# install drupal
[ -d $ACCOUNT_DIR/usr/local/drupal ] && rm -r $ACCOUNT_DIR/usr/local/drupal
mkdir $ACCOUNT_DIR/usr/local/drupal
install-drupal.sh --domain-dir $ACCOUNT_DIR/usr/local/domains --user "$ACCOUNT_USER" --dir $ACCOUNT_DIR/usr/local/drupal --drush-dir $ACCOUNT_DIR/usr/local/drush
cd $ACCOUNT_DIR/usr/local/drupal
install-drupal-site.sh \
    --drupal-dir $ACCOUNT_DIR/usr/local/drupal \
    --drush-dir $ACCOUNT_DIR/usr/local/drush \
    --domain-dir $ACCOUNT_DIR/usr/local/domains \
    --domain $DOMAIN_NEW \
    --user $ACCOUNT_USER \
    --db-name $CMS_DB_NAME \
    --db-user $CMS_DB_USER \
    --db-pass $CMS_DB_PASS
install-drupal-site.sh \
    --drupal-dir $ACCOUNT_DIR/usr/local/drupal \
    --drush-dir $ACCOUNT_DIR/usr/local/drush \
    --domain-dir $ACCOUNT_DIR/usr/local/domains \
    --domain $DOMAIN_DEV \
    --user $ACCOUNT_USER \
    --db-name $CMS_DB_NAME_DEV \
    --db-user $CMS_DB_USER_DEV \
    --db-pass $CMS_DB_PASS_DEV
cp -f $ACCOUNT_DIR/usr/local/drupal/sites/$DOMAIN_NEW/settings.php $ACCOUNT_DIR/usr/local/drupal/sites/default/settings.php

# configure drupal
$ACCOUNT_DIR/usr/local/drush/drush -y dl entity og profile2 field_permissions userpoints userpoints_nc switchtheme user_stats shoutbox faq collapsiblock
echo '1' | $ACCOUNT_DIR/usr/local/drush/drush dl visitors
MODULES="entity og profile2 field_permissions userpoints userpoints_nc switchtheme user_stats shoutbox faq visitors collapsiblock"
$ACCOUNT_DIR/usr/local/drush/drush --uri=http://$DOMAIN_NEW -y en $MODULES
$ACCOUNT_DIR/usr/local/drush/drush --uri=http://$DOMAIN_DEV -y en $MODULES
echo -e "\nSetEnv ENVIRONMENT production" >> $ACCOUNT_DIR/usr/local/domains/$DOMAIN_NEW/.htaccess
echo -e "\nSetEnv ENVIRONMENT development" >> $ACCOUNT_DIR/usr/local/domains/$DOMAIN_DEV/.htaccess
cp -f $HOST4GE_DIR/projects/mhaker.pl/favicon.ico $ACCOUNT_DIR/usr/local/drupal/misc
chown $ACCOUNT_USER:$ACCOUNT_USER $ACCOUNT_DIR/usr/local/drupal/misc/favicon.ico
cp -f $HOST4GE_DIR/projects/mhaker.pl/logo.png $ACCOUNT_DIR/usr/local/drupal/misc
chown $ACCOUNT_USER:$ACCOUNT_USER $ACCOUNT_DIR/usr/local/drupal/misc/logo.png
chown -R httpd:httpd sites/all/modules/contrib
cd $SCRIPT_WORKING_DIR

# install phpbb3
install-phpbb3.sh --user "$ACCOUNT_USER" --path $ACCOUNT_DIR/usr/local/drupal --dir-name "phpBB3" --db-name "$FORUM_DB_NAME" --db-user "$FORUM_DB_USER" --db-pass "$FORUM_DB_PASS"
mysql_create_database $FORUM_DB_NAME_DEV
mysql_create_user $FORUM_DB_NAME_DEV $FORUM_DB_USER_DEV $FORUM_DB_PASS_DEV
# dirs
mkdir $ACCOUNT_DIR/usr/local/domains/{$DOMAIN_NEW,$DOMAIN_DEV}/phpBB3
DIRS=`find $ACCOUNT_DIR/usr/local/drupal/phpBB3/ -maxdepth 1 -mindepth 1 -type d -exec basename {} \;`
for DIR in $DIRS; do
    ln -s $ACCOUNT_DIR/usr/local/drupal/phpBB3/$DIR $ACCOUNT_DIR/usr/local/domains/$DOMAIN_NEW/phpBB3/$DIR
    chown $ACCOUNT_USER:$ACCOUNT_USER $ACCOUNT_DIR/usr/local/domains/$DOMAIN_NEW/phpBB3/$DIR
    ln -s $ACCOUNT_DIR/usr/local/drupal/phpBB3/$DIR $ACCOUNT_DIR/usr/local/domains/$DOMAIN_DEV/phpBB3/$DIR
    chown $ACCOUNT_USER:$ACCOUNT_USER $ACCOUNT_DIR/usr/local/domains/$DOMAIN_DEV/phpBB3/$DIR
done
# files
cp $ACCOUNT_DIR/usr/local/drupal/phpBB3/.htaccess $ACCOUNT_DIR/usr/local/domains/$DOMAIN_NEW/phpBB3
cp $ACCOUNT_DIR/usr/local/drupal/phpBB3/.htaccess $ACCOUNT_DIR/usr/local/domains/$DOMAIN_DEV/phpBB3
FILES=`find $ACCOUNT_DIR/usr/local/drupal/phpBB3/*.php -type f -exec basename {} \;`
for FILE in $FILES; do
    cat <<EOF > $ACCOUNT_DIR/usr/local/domains/$DOMAIN_NEW/phpBB3/$FILE
<?php
	chdir('$ACCOUNT_DIR/usr/local/drupal/phpBB3/');
	\$file_name = substr(strrchr(__FILE__, '/'), 1);
	include('./' . \$file_name);
?>
EOF
    cp $ACCOUNT_DIR/usr/local/domains/$DOMAIN_NEW/phpBB3/$FILE $ACCOUNT_DIR/usr/local/domains/$DOMAIN_DEV/phpBB3
done
chown $ACCOUNT_USER:$ACCOUNT_USER $ACCOUNT_DIR/usr/local/domains/{$DOMAIN_NEW,$DOMAIN_DEV}/phpBB3/{.htaccess,*.php}

# install phpbbdrupalbridge
install-phpbbdrupalbridge.sh --user $ACCOUNT_USER \
    --drush-dir $ACCOUNT_DIR/usr/local/drush \
    --drupal-dir $ACCOUNT_DIR/usr/local/drupal \
    --phpbb3-dir $ACCOUNT_DIR/usr/local/drupal/phpBB3 \
	--domain $DOMAIN_NEW
cd $ACCOUNT_DIR/usr/local/drupal
$ACCOUNT_DIR/usr/local/drush/drush --uri=http://$DOMAIN_NEW -y en phpbbforum
$ACCOUNT_DIR/usr/local/drush/drush --uri=http://$DOMAIN_DEV -y en phpbbforum
cd $SCRIPT_WORKING_DIR

# configure phpbb3
rm -r $ACCOUNT_DIR/usr/local/drupal/phpBB3/install
rm $ACCOUNT_DIR/usr/local/domains/$DOMAIN_NEW/phpBB3/install
rm $ACCOUNT_DIR/usr/local/domains/$DOMAIN_DEV/phpBB3/install
mysql_restore_database_from_file $HOST4GE_DIR/projects/mhaker.pl/database-phpbb3.tar.gz $FORUM_DB_NAME
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
update users set user_regdate = 0, user_passchg = 0, user_lastmark = 0;
delete from search_wordmatch;
delete from search_wordlist;
delete from sessions;
EOF
cat <<EOF > $ACCOUNT_DIR/usr/local/drupal/phpBB3/config.php
<?php

\$dbms = 'mysql';
\$dbhost = '';
\$dbport = '';
\$dbname = (getenv('ENVIRONMENT') == 'production' || (defined('ENVIRONMENT') && ENVIRONMENT == 'production')) ? '$FORUM_DB_NAME' : '$FORUM_DB_NAME_DEV';
\$dbuser = (getenv('ENVIRONMENT') == 'production' || (defined('ENVIRONMENT') && ENVIRONMENT == 'production')) ? '$FORUM_DB_USER' : '$FORUM_DB_USER_DEV';
\$dbpasswd = (getenv('ENVIRONMENT') == 'production' || (defined('ENVIRONMENT') && ENVIRONMENT == 'production')) ? '$FORUM_DB_PASS' : '$FORUM_DB_PASS_DEV';
\$table_prefix = '';
\$acm_type = 'file';
\$load_extensions = '';

@define('PHPBB_INSTALLED', true);

?>
EOF
chown -R $ACCOUNT_USER:$ACCOUNT_USER $ACCOUNT_DIR/usr/local/drupal/phpBB3/config.php

# configure cms datbase
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
delete from $CMS_DB_NAME.variable where name like 'phpbbforum_%';
insert into $CMS_DB_NAME.variable (name, value) values
    ('phpbbforum_admin_user_id', 's:1:"2";'),
    ('phpbbforum_api_file', 's:13:"phpbb_api.php";'),
    ('phpbbforum_commentlink_text_comments', 's:7:"Discuss";'),
    ('phpbbforum_commentlink_text_nocomments', 's:7:"Discuss";'),
    ('phpbbforum_inc', 's:64:"sites/all/modules/contrib/phpbbforum/includes/phpbbdrupalbridge/";'),
    ('phpbbforum_language', 's:1:"0";'),
    ('phpbbforum_log_msg', 's:1:"1";'),
    ('phpbbforum_map_user_aim', 's:9:"field_aim";'),
    ('phpbbforum_map_user_birthday', 's:14:"field_birthday";'),
    ('phpbbforum_map_user_from', 's:10:"field_from";'),
    ('phpbbforum_map_user_gender', 's:12:"field_gender";'),
    ('phpbbforum_map_user_icq', 's:9:"field_icq";'),
    ('phpbbforum_map_user_interests', 's:15:"field_interests";'),
    ('phpbbforum_map_user_jabber', 's:12:"field_jabber";'),
    ('phpbbforum_map_user_msnm', 's:10:"field_msnm";'),
    ('phpbbforum_map_user_occ', 's:9:"field_occ";'),
    ('phpbbforum_map_user_role_3', 'a:3:{i:5;s:1:"5";i:4;s:1:"4";i:7;s:1:"7";}'),
    ('phpbbforum_map_user_website', 's:13:"field_website";'),
    ('phpbbforum_map_user_yim', 's:9:"field_yim";'),
    ('phpbbforum_master', 's:1:"0";'),
    ('phpbbforum_num_recent_new_sort_days', 's:1:"0";'),
    ('phpbbforum_num_recent_posts', 's:2:"10";'),
    ('phpbbforum_num_recent_sort_days', 's:1:"0";'),
    ('phpbbforum_num_recent_topics', 's:2:"10";'),
    ('phpbbforum_num_whos_online', 's:4:"9999";'),
    ('phpbbforum_page_frame', 's:1:"2";'),
    ('phpbbforum_pm_display_mode', 's:1:"0";'),
    ('phpbbforum_qookie_test', 'i:1;'),
    ('phpbbforum_recent_display_topic_new_icon_pos', 's:1:"0";'),
    ('phpbbforum_recent_posts_br', 's:1:"1";'),
    ('phpbbforum_recent_posts_display_mode', 's:1:"0";'),
    ('phpbbforum_recent_topics_br', 's:1:"1";'),
    ('phpbbforum_recent_topics_display_mode', 's:1:"0";'),
    ('phpbbforum_root', 's:50:"./phpBB3/";'),
    ('phpbbforum_set_msg', 's:1:"1";'),
    ('phpbbforum_submission', 's:1:"1";'),
    ('phpbbforum_sync_avatar', 's:1:"1";'),
    ('phpbbforum_sync_signature', 's:1:"1";'),
    ('phpbbforum_sync_timezone', 's:1:"1";'),
    ('phpbbforum_topic_backlink_text', 's:4:"Read";'),
    ('phpbbforum_user_ban', 's:1:"1";'),
    ('phpbbforum_user_group', 's:1:"2";'),
    ('phpbbforum_user_role', 's:1:"2";'),
    ('phpbbforum_user_roles_sync', 's:1:"1";');
delete from $CMS_DB_NAME.variable where name like 'user_%';
insert into $CMS_DB_NAME.variable (name, value) values
    ('userpoints_category_default_vid', 's:1:"2";'),
    ('user_admin_role', 's:1:"3";'),
    ('user_cancel_method', 's:17:"user_cancel_block";'),
    ('user_email_verification', 'i:1;'),
    ('user_mail_cancel_confirm_body', 's:396:"[user:name],\r\n\r\nZostała uruchomiona procedura anulowania Twojego konta na stronie  [site:name].\r\n\r\nMożesz anulować swoje konto na stronie [site:url-brief] klikając poniższy odnośnik bądź kopiując go w pole adresu przeglądarki:\r\n\r\n[user:cancel-url]\r\n\r\nUWAGA: anulowanie konta jest operacją nieodwracalną.\r\n\r\nOdnośnik straci ważność po jednym dniu.\r\n\r\n-- redakcja strony [site:name]";'),
    ('user_mail_cancel_confirm_subject', 's:61:"Prośba o usunięcie konta [user:name] na stronie [site:name]";'),
    ('user_mail_password_reset_body', 's:407:"[user:name],\r\n\r\nW serwisie [site:name] została uruchomiona procedura resetowania twojego hasła.\r\n\r\nMożesz się zalogować klikając poniższy odnośnik bądź kopiując go w pole adresu przeglądarki:\r\n\r\n[user:one-time-login-url]\r\n\r\nOdnośnik może zostać użyty tylko raz a jego użycie umożliwi wpisanie własnego hasła. Odnośnik straci ważność po jednym dniu.\r\n\r\n--  redakcja strony [site:name]";'),
    ('user_mail_password_reset_subject', 's:70:"Odzyskiwanie hasła dla użytkownika [user:name] ze strony [site:name]";'),
    ('user_mail_register_admin_created_body', 's:527:"[user:name],\r\n\r\nAdministrator strony [site:name] utworzył dla Ciebie konto. Możesz się zalogować klikając poniższy odnośnik bądź kopiując go w pole adresu przeglądarki:\r\n\r\n[user:one-time-login-url]\r\n\r\nOdnośnik może zostać użyty tylko raz a jego użycie umożliwi wpisanie własnego hasła.\r\n\r\nPo ustawieniu swojego hasła będzie można zalogować się do serwisu pod adresem [site:login-url] wykorzystując poniższe dane:\r\n\r\nnazwa konta: [user:name]\r\nhasło: Ustawione hasło\r\n\r\n--  redakcja strony [site:name]";'),
    ('user_mail_register_admin_created_subject', 's:63:"Administrator utworzył dla ciebie konto na stronie [site:name]";'),
    ('user_mail_register_no_approval_required_body', 's:510:"[user:name],\r\n\r\nDziękujemy za rejestrację na [site:name]. Możesz się zalogować klikając poniższy odnośnik bądź kopiując go w pole adresu przeglądarki:\r\n\r\n[user:one-time-login-url]\r\n\r\nOdnośnik może zostać użyty tylko raz a jego użycie umożliwi wpisanie własnego hasła.\r\n\r\nPo ustawieniu swojego hasła będzie można zalogować się do serwisu pod adresem [site:login-url] wykorzystując poniższe dane:\r\n\r\nnazwa konta: [user:name]\r\nhasło: Ustawione hasło\r\n\r\n--  redakcja strony [site:name]";'),
    ('user_mail_register_no_approval_required_subject', 's:52:"Szczegóły konta [user:name] na stronie [site:name]";'),
    ('user_mail_register_pending_approval_body', 's:263:"[user:name],\r\n\r\nDziękujemy za rejestrację na stronie [site:name]. Twoje konto oczekuje na aprobatę administratora. W chwili zakończenia tego procesu otrzymasz e-mail zawierający dane potrzebne do zalogowania się do serwisu.\r\n\r\n-- redakcja strony [site:name]";'),
    ('user_mail_register_pending_approval_subject', 's:104:"Szczegóły konta [user:name] na stronie [site:name] (oczekiwanie na zatwierdzenie przez administratora)";'),
    ('user_mail_status_activated_body', 's:522:"[user:name],\r\n\r\nTwoje konto na stronie [site:name] zostało aktywowane. Możesz się zalogować klikając poniższy odnośnik bądź kopiując go w pole adresu przeglądarki:\r\n\r\n[user:one-time-login-url]\r\n\r\nOdnośnik może zostać użyty tylko raz a jego użycie umożliwi wpisanie własnego hasła.\r\n\r\nPo ustawieniu swojego hasła będzie można zalogować się do serwisu pod adresem [site:login-url] wykorzystując poniższe dane:\r\n\r\nnazwa konta: [user:name]\r\nhasło: Ustawione hasło\r\n\r\n--  redakcja strony [site:name]";'),
    ('user_mail_status_activated_notify', 'i:1;'),
    ('user_mail_status_activated_subject', 's:67:"Szczegóły konta [user:name] na stronie [site:name] (zatwierdzony)";'),
    ('user_mail_status_blocked_body', 's:106:"[user:name],\r\n\r\nTwoje konto na stronie [site:name] zostało zablokowane.\r\n\r\n-- redakcja strony [site:name]";'),
    ('user_mail_status_blocked_notify', 'i:0;'),
    ('user_mail_status_blocked_subject', 's:66:"Szczegóły konta [user:name] na stronie [site:name] (zablokowany)";'),
    ('user_mail_status_canceled_body', 's:104:"[user:name],\r\n\r\nTwoje konto na stronie [site:name] zostało anulowane.\r\n\r\n-- redakcja strony [site:name]";'),
    ('user_mail_status_canceled_notify', 'i:0;'),
    ('user_mail_status_canceled_subject', 's:64:"Szczegóły konta [user:name] na stronie [site:name] (usunięty)";'),
    ('user_pictures', 'i:1;'),
    ('user_picture_default', 's:0:"";'),
    ('user_picture_dimensions', 's:9:"1024x1024";'),
    ('user_picture_file_size', 's:3:"800";'),
    ('user_picture_guidelines', 's:0:"";'),
    ('user_picture_path', 's:8:"pictures";'),
    ('user_picture_style', 's:9:"thumbnail";'),
    ('user_register', 's:1:"0";'),
    ('user_signatures', 'i:0;');
delete from $CMS_DB_NAME.url_alias where source like 'phpbbforum%';
insert into $CMS_DB_NAME.url_alias (source, alias, language) values
    ('phpbbforum', 'forum', 'und'),
    ('phpbbforum/index.php', 'forum/index.php', 'und'),
    ('phpbbforum/viewtopic.php', 'forum/viewtopic.php', 'und'),
    ('phpbbforum/viewforum.php', 'forum/viewforum.php', 'und'),
    ('phpbbforum/viewonline.php', 'forum/viewonline.php', 'und'),
    ('phpbbforum/memberlist.php', 'forum/memberlist.php', 'und'),
    ('phpbbforum/posting.php', 'forum/posting.php', 'und'),
    ('phpbbforum/search.php', 'forum/search.php', 'und'),
    ('phpbbforum/ucp.php', 'forum/ucp.php', 'und'),
    ('phpbbforum/mcp.php', 'forum/mcp.php', 'und'),
    ('phpbbforum/faq.php', 'forum/faq.php', 'und'),
    ('phpbbforum/report.php', 'forum/report.php', 'und'),
    ('phpbbforum/adm/index.php', 'forum/adm/index.php', 'und');
delete from $CMS_DB_NAME.variable where name = 'path_alias_whitelist';
insert into $CMS_DB_NAME.variable (name, value) values
    ('path_alias_whitelist', 'a:1:{s:10:"phpbbforum";b:1;}');
alter table $CMS_DB_NAME.users character set utf8 collate utf8_general_ci;
alter table $CMS_DB_NAME.users modify name varchar(60) character set utf8 collate utf8_polish_ci;
alter table $CMS_DB_NAME.users modify mail varchar(60) character set utf8 collate utf8_general_ci;
EOF

# configure forum datbase
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
update $FORUM_DB_NAME.config set config_value = 1 where config_name = 'min_name_chars';
update $FORUM_DB_NAME.config set config_value = 50 where config_name = 'max_name_chars';
update $FORUM_DB_NAME.config set config_value = 1 where config_name = 'allow_namechange';
update $FORUM_DB_NAME.config set config_value = 1 where config_name = 'allow_emailreuse';
update $FORUM_DB_NAME.config set config_value = 0 where config_name = 'email_check_mx';
update $FORUM_DB_NAME.config set config_value = 0 where config_name = 'load_birthdays';
update $FORUM_DB_NAME.config set config_value = 0 where config_name = 'allow_birthdays';
update $FORUM_DB_NAME.config set config_value = 1 where config_name = 'load_tplcompile';
update $FORUM_DB_NAME.config set config_value = 3 where config_name = 'require_activation';
update $FORUM_DB_NAME.config set config_value = 'mhaker.pl' where config_name = 'sitename';
update $FORUM_DB_NAME.config set config_value = 'Administrator\\nhttp://mhaker.pl' where config_name = 'board_email_sig';
update $FORUM_DB_NAME.config set config_value = 'mhaker.pl' where config_name = 'cookie_domain';
update $FORUM_DB_NAME.config set config_value = 'forum' where config_name = 'cookie_name';
update $FORUM_DB_NAME.config set config_value = 'mhaker.pl' where config_name = 'server_name';
alter table $FORUM_DB_NAME.users character set utf8 collate utf8_general_ci;
alter table $FORUM_DB_NAME.users modify username varchar(255) character set utf8 collate utf8_polish_ci;
alter table $FORUM_DB_NAME.users modify username_clean varchar(255) character set utf8 collate utf8_polish_ci;
alter table $FORUM_DB_NAME.users modify user_email varchar(100) character set utf8 collate utf8_general_ci;
EOF

# install zend framework
install-zendframework.sh --user $ACCOUNT_USER --path $ACCOUNT_DIR/usr/local/drupal --dir-name zendframework

#
# mhaker forum migration
#

echo "mhaker forum migration"

cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
delete from acl_groups;
insert into acl_groups (group_id, forum_id, auth_option_id, auth_role_id, auth_setting) values
(1, 0, 85, 0, 1),(1, 0, 93, 0, 1),(1, 0, 111, 0, 1),(5, 0, 0, 5, 0),(5, 0, 0, 1, 0),(2, 0, 0, 6, 0),(3, 0, 0, 6, 0),(4, 0, 0, 5, 0),(4, 0, 0, 10, 0),(7, 0, 0, 23, 0),(5, 3, 0, 14, 0),(5, 4, 0, 14, 0),(5, 5, 0, 14, 0),(5, 6, 0, 14, 0),(5, 7, 0, 14, 0),(5, 8, 0, 14, 0),(5, 9, 0, 14, 0),(5, 10, 0, 14, 0),(5, 11, 0, 14, 0),(5, 12, 0, 14, 0),(5, 13, 0, 14, 0),(5, 14, 0, 14, 0),(5, 15, 0, 14, 0),(5, 16, 0, 14, 0),(6, 3, 0, 19, 0),(6, 4, 0, 19, 0),(6, 5, 0, 19, 0),(6, 6, 0, 19, 0),(6, 7, 0, 19, 0),(6, 8, 0, 19, 0),(6, 9, 0, 19, 0),(6, 10, 0, 19, 0),(6, 11, 0, 19, 0),(6, 12, 0, 19, 0),(6, 13, 0, 19, 0),(6, 14, 0, 19, 0),(6, 15, 0, 19, 0),(6, 16, 0, 19, 0),(4, 3, 0, 14, 0),(4, 4, 0, 14, 0),(4, 5, 0, 14, 0),(4, 6, 0, 14, 0),(4, 7, 0, 14, 0),(4, 8, 0, 14, 0),(4, 9, 0, 14, 0),(4, 10, 0, 14, 0),(4, 11, 0, 14, 0),(4, 12, 0, 14, 0),(4, 13, 0, 14, 0),(4, 14, 0, 14, 0),(4, 15, 0, 14, 0),(4, 16, 0, 14, 0),(1, 3, 0, 17, 0),(1, 4, 0, 17, 0),(1, 5, 0, 17, 0),(1, 6, 0, 17, 0),(1, 7, 0, 17, 0),(1, 8, 0, 17, 0),(1, 9, 0, 17, 0),(1, 10, 0, 17, 0),(1, 11, 0, 17, 0),(1, 12, 0, 17, 0),(1, 13, 0, 17, 0),(1, 14, 0, 17, 0),(1, 15, 0, 17, 0),(1, 16, 0, 17, 0),(7, 3, 0, 17, 0),(7, 4, 0, 17, 0),(7, 5, 0, 17, 0),(7, 6, 0, 17, 0),(7, 7, 0, 17, 0),(7, 8, 0, 17, 0),(7, 9, 0, 17, 0),(7, 10, 0, 17, 0),(7, 11, 0, 17, 0),(7, 12, 0, 17, 0),(7, 13, 0, 17, 0),(7, 14, 0, 17, 0),(7, 15, 0, 17, 0),(7, 16, 0, 17, 0),(2, 3, 0, 15, 0),(2, 4, 0, 15, 0),(2, 5, 0, 15, 0),(2, 6, 0, 15, 0),(2, 7, 0, 15, 0),(2, 8, 0, 15, 0),(2, 9, 0, 15, 0),(2, 10, 0, 15, 0),(2, 11, 0, 15, 0),(2, 12, 0, 15, 0),(2, 13, 0, 15, 0),(2, 14, 0, 15, 0),(2, 15, 0, 15, 0),(2, 16, 0, 15, 0);
EOF

cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
delete from acl_roles_data;
insert into acl_roles_data (role_id, auth_option_id, auth_setting) values
(1, 44, 1),(1, 46, 1),(1, 47, 1),(1, 48, 1),(1, 50, 1),(1, 51, 1),(1, 52, 1),(1, 56, 1),(1, 57, 1),(1, 58, 1),(1, 59, 1),(1, 60, 1),(1, 61, 1),(1, 62, 1),(1, 63, 1),(1, 66, 1),(1, 68, 1),(1, 70, 1),(1, 71, 1),(1, 72, 1),(1, 73, 1),(1, 79, 1),(1, 80, 1),(1, 81, 1),(1, 82, 1),(1, 83, 1),(1, 84, 1),(2, 44, 1),(2, 47, 1),(2, 48, 1),(2, 56, 1),(2, 57, 1),(2, 58, 1),(2, 59, 1),(2, 66, 1),(2, 71, 1),(2, 79, 1),(2, 82, 1),(2, 83, 1),(3, 44, 1),(3, 47, 1),(3, 48, 1),(3, 50, 1),(3, 60, 1),(3, 61, 1),(3, 62, 1),(3, 72, 1),(3, 79, 1),(3, 80, 1),(3, 82, 1),(3, 83, 1),(4, 44, 1),(4, 45, 1),(4, 46, 1),(4, 47, 1),(4, 48, 1),(4, 49, 1),(4, 50, 1),(4, 51, 1),(4, 52, 1),(4, 53, 1),(4, 54, 1),(4, 55, 1),(4, 56, 1),(4, 57, 1),(4, 58, 1),(4, 59, 1),(4, 60, 1),(4, 61, 1),(4, 62, 1),(4, 63, 1),(4, 64, 1),(4, 65, 1),(4, 66, 1),(4, 67, 1),(4, 68, 1),(4, 69, 1),(4, 70, 1),(4, 71, 1),(4, 72, 1),(4, 73, 1),(4, 74, 1),(4, 75, 1),(4, 76, 1),(4, 77, 1),(4, 78, 1),(4, 79, 1),(4, 80, 1),(4, 81, 1),(4, 82, 1),(4, 83, 1),(4, 84, 1),(5, 85, 1),(5, 86, 1),(5, 87, 1),(5, 88, 1),(5, 89, 1),(5, 90, 1),(5, 91, 1),(5, 92, 1),(5, 93, 1),(5, 94, 1),(5, 95, 1),(5, 96, 1),(5, 97, 1),(5, 98, 1),(5, 99, 1),(5, 100, 1),(5, 101, 1),(5, 102, 1),(5, 103, 1),(5, 104, 1),(5, 105, 1),(5, 106, 1),(5, 107, 1),(5, 108, 1),(5, 109, 1),(5, 110, 1),(5, 111, 1),(5, 112, 1),(5, 113, 1),(5, 114, 1),(5, 115, 1),(5, 116, 1),(5, 117, 1),(6, 85, 1),(6, 86, 1),(6, 87, 1),(6, 88, 1),(6, 89, 1),(6, 92, 1),(6, 93, 1),(6, 94, 1),(6, 96, 1),(6, 97, 1),(6, 98, 1),(6, 99, 1),(6, 100, 1),(6, 101, 1),(6, 102, 1),(6, 103, 1),(6, 106, 1),(6, 107, 1),(6, 108, 1),(6, 109, 1),(6, 110, 1),(6, 111, 1),(6, 112, 1),(6, 113, 1),(6, 114, 1),(6, 115, 1),(6, 117, 1),(7, 85, 1),(7, 87, 1),(7, 88, 1),(7, 89, 1),(7, 92, 1),(7, 93, 1),(7, 94, 1),(7, 99, 1),(7, 100, 1),(7, 101, 1),(7, 102, 1),(7, 105, 1),(7, 106, 1),(7, 107, 1),(7, 108, 1),(7, 109, 1),(7, 114, 1),(7, 115, 1),(7, 117, 1),(8, 85, 1),(8, 87, 1),(8, 88, 1),(8, 89, 1),(8, 92, 1),(8, 93, 1),(8, 94, 1),(8, 96, 0),(8, 97, 0),(8, 109, 0),(8, 114, 0),(8, 115, 1),(8, 117, 1),(9, 85, 1),(9, 87, 0),(9, 88, 1),(9, 89, 1),(9, 92, 1),(9, 93, 1),(9, 94, 1),(9, 99, 1),(9, 100, 1),(9, 101, 1),(9, 102, 1),(9, 105, 1),(9, 106, 1),(9, 107, 1),(9, 108, 1),(9, 109, 1),(9, 114, 1),(9, 115, 1),(9, 117, 1),(10, 31, 1),(10, 32, 1),(10, 33, 1),(10, 34, 1),(10, 35, 1),(10, 36, 1),(10, 37, 1),(10, 38, 1),(10, 39, 1),(10, 40, 1),(10, 41, 1),(10, 42, 1),(10, 43, 1),(11, 31, 1),(11, 32, 1),(11, 34, 1),(11, 35, 1),(11, 36, 1),(11, 37, 1),(11, 38, 1),(11, 39, 1),(11, 40, 1),(11, 41, 1),(11, 43, 1),(12, 31, 1),(12, 34, 1),(12, 35, 1),(12, 36, 1),(12, 40, 1),(13, 31, 1),(13, 32, 1),(13, 35, 1),(14, 1, 1),(14, 2, 1),(14, 3, 1),(14, 4, 1),(14, 5, 1),(14, 6, 1),(14, 7, 1),(14, 8, 1),(14, 9, 1),(14, 10, 1),(14, 11, 1),(14, 12, 1),(14, 13, 1),(14, 14, 1),(14, 15, 1),(14, 16, 1),(14, 17, 1),(14, 18, 1),(14, 19, 1),(14, 20, 1),(14, 21, 1),(14, 22, 1),(14, 23, 1),(14, 24, 1),(14, 25, 1),(14, 26, 1),(14, 27, 1),(14, 28, 1),(14, 29, 1),(14, 30, 1),(15, 1, 1),(15, 3, 1),(15, 4, 1),(15, 5, 1),(15, 6, 1),(15, 7, 1),(15, 8, 1),(15, 9, 1),(15, 11, 1),(15, 13, 1),(15, 14, 1),(15, 15, 1),(15, 17, 1),(15, 18, 1),(15, 19, 1),(15, 20, 1),(15, 21, 1),(15, 22, 1),(15, 23, 1),(15, 24, 1),(15, 25, 1),(15, 27, 1),(15, 29, 1),(15, 30, 1),(16, 1, 0),(17, 1, 1),(17, 7, 1),(17, 14, 1),(17, 19, 1),(17, 20, 1),(17, 23, 1),(17, 27, 1),(18, 1, 1),(18, 4, 1),(18, 7, 1),(18, 8, 1),(18, 9, 1),(18, 13, 1),(18, 14, 1),(18, 15, 1),(18, 17, 1),(18, 18, 1),(18, 19, 1),(18, 20, 1),(18, 21, 1),(18, 22, 1),(18, 23, 1),(18, 24, 1),(18, 25, 1),(18, 27, 1),(18, 29, 1),(19, 1, 1),(19, 7, 1),(19, 14, 1),(19, 19, 1),(19, 20, 1),(20, 1, 1),(20, 3, 1),(20, 4, 1),(20, 7, 1),(20, 8, 1),(20, 9, 1),(20, 13, 1),(20, 14, 1),(20, 15, 0),(20, 17, 1),(20, 18, 1),(20, 19, 1),(20, 20, 1),(20, 21, 1),(20, 22, 1),(20, 23, 1),(20, 24, 1),(20, 25, 1),(20, 27, 1),(20, 29, 1),(21, 1, 1),(21, 3, 1),(21, 4, 1),(21, 5, 1),(21, 6, 1),(21, 7, 1),(21, 8, 1),(21, 9, 1),(21, 11, 1),(21, 13, 1),(21, 14, 1),(21, 15, 1),(21, 16, 1),(21, 17, 1),(21, 18, 1),(21, 19, 1),(21, 20, 1),(21, 21, 1),(21, 22, 1),(21, 23, 1),(21, 24, 1),(21, 25, 1),(21, 27, 1),(21, 29, 1),(21, 30, 1),(22, 1, 1),(22, 4, 1),(22, 7, 1),(22, 8, 1),(22, 9, 1),(22, 13, 1),(22, 14, 1),(22, 15, 1),(22, 16, 1),(22, 17, 1),(22, 18, 1),(22, 19, 1),(22, 20, 1),(22, 21, 1),(22, 22, 1),(22, 23, 1),(22, 24, 1),(22, 25, 1),(22, 27, 1),(22, 29, 1),(23, 96, 0),(23, 97, 0),(23, 114, 0),(24, 15, 0);
EOF

cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
delete from forums;
insert into forums (forum_id, parent_id, left_id, right_id, forum_parents, forum_name, forum_desc, forum_desc_bitfield, forum_desc_options, forum_desc_uid, forum_link, forum_password, forum_style, forum_image, forum_rules, forum_rules_link, forum_rules_bitfield, forum_rules_options, forum_rules_uid, forum_topics_per_page, forum_type, forum_status, forum_posts, forum_topics, forum_topics_real, forum_last_post_id, forum_last_poster_id, forum_last_post_subject, forum_last_post_time, forum_last_poster_name, forum_last_poster_colour, forum_flags, forum_options, display_subforum_list, display_on_index, enable_indexing, enable_icons, enable_prune, prune_next, prune_days, prune_viewed, prune_freq) values
(3, 0, 1, 6, '', 'Opinie i uwagi', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', '', 32, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(4, 3, 2, 3, '', 'Opinie i uwagi', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(5, 3, 4, 5, '', 'Problemy i skargi', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(6, 0, 7, 20, '', 'Hacking | Security', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', '', 32, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(7, 6, 8, 9, '', 'Hacking', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(8, 6, 10, 11, '', 'Security', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(9, 6, 12, 13, '', 'Strefa zrzutu', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(10, 6, 14, 15, '', 'Toturiale', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(11, 6, 16, 17, '', 'Systemy', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(12, 6, 18, 19, '', 'GSM', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(13, 0, 21, 28, '', 'Inne', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 0, 0, 0, 0, 0, 0, 0, '', 0, '', '', 32, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(14, 13, 22, 23, '', 'Programowanie', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(15, 13, 24, 25, '', 'Off topic', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1),
(16, 13, 26, 27, '', 'Kosz', '', '', 7, '', '', '', 0, '', '', '', '', 7, '', 0, 1, 0, 0, 0, 0, 0, 0, '', 0, '', '', 48, 0, 1, 0, 1, 0, 0, 0, 7, 7, 1);
EOF

rm $ACCOUNT_DIR/usr/local/drupal/phpBB3/cache/*.php > /dev/null 2>&1
cd $ACCOUNT_DIR/usr/local/drupal

# migrate users
echo "migrate users"
chmod 500 $HOST4GE_DIR/projects/mhaker.pl/migrate_users.php
$HOST4GE_DIR/projects/mhaker.pl/migrate_users.php "$DB_ROOT_PASSWORD" 0
sleep 10
$HOST4GE_DIR/projects/mhaker.pl/migrate_users.php "$DB_ROOT_PASSWORD" 1
sleep 10
$HOST4GE_DIR/projects/mhaker.pl/migrate_users.php "$DB_ROOT_PASSWORD" 2
sleep 10
$HOST4GE_DIR/projects/mhaker.pl/migrate_users.php "$DB_ROOT_PASSWORD" 3
sleep 10
$HOST4GE_DIR/projects/mhaker.pl/migrate_users.php "$DB_ROOT_PASSWORD" 4

# migrate posts
echo "migrate posts"
chmod 500 $HOST4GE_DIR/projects/mhaker.pl/migrate_posts.php
$HOST4GE_DIR/projects/mhaker.pl/migrate_posts.php "$DB_ROOT_PASSWORD"

# migrate config
echo "migrate config"
chmod 500 $HOST4GE_DIR/projects/mhaker.pl/migrate_config.php
$HOST4GE_DIR/projects/mhaker.pl/migrate_config.php "$DB_ROOT_PASSWORD"

# update topic visits
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
drop table if exists temp;
create table temp (id int, count int);
insert into temp (id, count)
select nt.topic_id, t.visits
from
	$MHAKER_DB_NAME.mhaker_forum_messages m,
	$MHAKER_DB_NAME.mhaker_forum_topics t,
	$MHAKER_DB_NAME.mhaker_forum_forums f,
	forums nf,
	topics nt
where
	m.topic = t.id and
	t.forum = f.id and
	f.name =  nf.forum_name and
	nf.forum_type = 1 and
	m.new_topic = 1 and
	nt.forum_id = nf.forum_id and
	nt.topic_time = unix_timestamp(m.time)
order by
	f.id, t.id, m.id;
update topics, temp
set topics.topic_views = temp.count
where topics.topic_id = temp.id;
drop table if exists temp;
EOF

# update user data
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
create unique index username on users (username) using btree;
update
	$MHAKER_DB_NAME.mhaker_users u1, users u2
set
	u2.user_ip = u1.user_last_ip,
	u2.user_regdate = unix_timestamp(u1.user_regdate),
	u2.user_birthday = unix_timestamp(u1.user_birthday),
	u2.user_lastvisit = unix_timestamp(u1.user_lastvisit),
	u2.user_lang = 'pl',
	u2.user_timezone = 1,
	u2.user_dst = 1,
	u2.user_sig = u1.user_sig,
	u2.user_from = u1.user_from,
	u2.user_website = u1.user_website,
	u2.user_occ = u1.user_occ,
	u2.user_interests = u1.user_interests
where
	u1.user_name = u2.username and
	u2.username_clean not in ('anonim', 'nimda');
EOF

# update post count for each user
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
drop table if exists temp;
create table temp (name varchar(255) character set utf8 collate utf8_polish_ci, count int);
insert into temp (name, count)
select
	post_username, count(1) as count
from
	posts
group
	by post_username
order
	by count desc;
update users, temp
set users.user_posts = temp.count
where users.username = temp.name;
drop table if exists temp;
EOF

# correct forum name
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
update forums set forum_name = 'Tutoriale' where forum_name = 'Toturiale';
EOF

# configure cms timezone
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $CMS_DB_NAME;
update users set timezone = 'Europe/Warsaw';
EOF

#
# copy test databases
#

mysql_copy_tables $CMS_DB_NAME $CMS_DB_NAME_DEV
mysql_copy_tables $FORUM_DB_NAME $FORUM_DB_NAME_DEV

#
# clear
#

cd $ACCOUNT_DIR/usr/local/drupal

echo '1' | $ACCOUNT_DIR/usr/local/drush/drush --uri=http://$DOMAIN_NEW cache-clear
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $CMS_DB_NAME;
delete from watchdog;
EOF

rm $ACCOUNT_DIR/usr/local/drupal/phpBB3/cache/*.php > /dev/null 2>&1
cat <<EOF | mysql --user="root" --password="$DB_ROOT_PASSWORD"
use $FORUM_DB_NAME;
delete from sessions;
EOF

cd $SCRIPT_WORKING_DIR

#
# dump database
#

rm -r $ACCOUNT_DIR/usr/local/databases/{$CMS_DB_NAME,$FORUM_DB_NAME}
mkdir -p $ACCOUNT_DIR/usr/local/databases/{$CMS_DB_NAME,$FORUM_DB_NAME}
mysql_dump_database $CMS_DB_NAME $ACCOUNT_DIR/usr/local/databases/$CMS_DB_NAME
mysql_dump_database $FORUM_DB_NAME $ACCOUNT_DIR/usr/local/databases/$FORUM_DB_NAME
chown -R $ACCOUNT_USER:$ACCOUNT_USER $ACCOUNT_DIR/usr/local/databases

#
# version control
#

cd $ACCOUNT_DIR/usr/local
rm -r .git
cat <<EOF > .gitignore
databases/$MHAKER_DB_NAME/
domains/$DOMAIN_OLD/
drupal/phpBB3/cache/
drupal/zendframework/
drush/
EOF
git init
git config core.autocrlf false
git config core.filemode true
git config user.name "Daniel Stefaniuk"
git config user.email "daniel.stefaniuk@gmail.com"
git add .
git commit -m "initial commit"
chown root:root .git*
chmod 700 .git
chmod 400 .gitignore
cd $SCRIPT_WORKING_DIR

exit 0
