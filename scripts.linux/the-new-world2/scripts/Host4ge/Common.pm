package Host4ge::Common;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.1';

our @EXPORT = qw(

	INSTALL_DIR
	LOG_DIR
	BACKUP_DIR
	USER_ACCOUNT_PATH
	USER_ACCOUNT_PUBLIC_DIR

	SSH_JAIL_GROUP
	SSH_JAIL_GID
	USER_MIN_ID
	USER_MAX_ID

	generate_random_string
	generate_certificate

	user_exists
	user_can_create
	user_create
	user_passwd_change
	user_id
	user_disable
	user_is_disabled
	user_remove
	user_get_list

);

use Host4ge::Util;

use File::Path;
use File::Spec::Unix;

# directories
use constant INSTALL_DIR => '/srv';
use constant LOG_DIR => '/var/log';
use constant BACKUP_DIR => INSTALL_DIR . '/backup';
use constant USER_ACCOUNT_PATH => INSTALL_DIR . '/accounts';
use constant USER_ACCOUNT_PUBLIC_DIR => 'www/public';

# user
use constant SSH_JAIL_GROUP => 'sshjail';
use constant SSH_JAIL_GID => 10000;
use constant USER_MIN_ID => 10001;
use constant USER_MAX_ID => 19999;

# generate_random_string($length)
sub generate_random_string {

	my $length = shift;
	my @chars = ('a'..'z', 'A'..'Z', '0'..'9');
	my $random_string;

	foreach (1..$length) {
		$random_string .= $chars[rand @chars];
	}

	return $random_string;
}

# generate_certificate($name)
sub generate_certificate {

	my $name = shift;
	my $install_dir = INSTALL_DIR;

	system("openssl req -new -x509 -nodes -sha1 -newkey rsa:2048 -days 1095 -subj '/O=unknown/OU=unknown/CN=$name' -keyout $install_dir/openssl/certs/$name.key -out $install_dir/openssl/certs/$name.crt > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		return handle_error($?);
	}

	system("cat $install_dir/openssl/certs/$name.crt $install_dir/openssl/certs/$name.key > $install_dir/openssl/certs/$name.pem");
	# handle error
	if ($? != 0) {
		return handle_error($?);
	}

	system("chmod 400 $install_dir/openssl/certs/$name.crt");
	system("chmod 400 $install_dir/openssl/certs/$name.key");
	system("chmod 400 $install_dir/openssl/certs/$name.pem");
	# handle error
	if ($? != 0) {
		return handle_error($?);
	}
	else {
		log_msg('info', "certificate '$name' generated");
		return 0;
	}
}

# _user_create_generic($user, $group, $groups, $password, $home_dir, $shell, $min_uid, $max_uid, $min_gid, $max_gid)
sub _user_create_generic {

	my $user = shift;
	my $group = shift;
	my $groups = shift;
	my $password = shift;
	my $home_dir = shift;
	my $shell = shift;
	my $min_uid = shift;
	my $max_uid = shift;
	my $min_gid = shift;
	my $max_gid = shift;

	system("groupadd $group > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		return handle_error($?);
	}
	else {
		log_msg('info', "group '$user' created");
	}

	system("useradd -K UID_MIN=$min_uid -K UID_MAX=$max_uid -K GID_MIN=$min_gid -K GID_MAX=$max_gid -d $home_dir -s $shell -p `mkpasswd -m SHA-512 $password` -g $group -G $groups $user > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		return handle_error($?);
	}
	else {
		log_msg('info', "user '$user' created");
		return 0;
	}
}

# _user_remove_generic($user)
sub _user_remove_generic {

	my $user = shift;

	system("userdel -fr $user > /dev/null 2>&1");
	# handle error
	if ($? != 0 && ($? >> 8) != 12) { # 12 => userdel: warning: can't remove /var/mail/user: No such file or directory
		return handle_error($?);
	}
	else {
		log_msg('info', "user '$user' removed");
		return 0;
	}
}

# user_exists($user)
sub user_exists {

	my ($user) = @_;

	if (`grep "^$user:" /etc/passwd | wc -l` == 1) {
		my $id = `id -u $user`;
		if($id >= USER_MIN_ID && $id <= USER_MAX_ID) {
			return TRUE;
		}
	}

	return FALSE;
}

# user_can_create($user)
sub user_can_create {

	my $user = shift;

	if (`grep "^$user:" /etc/passwd | wc -l` == 1) {
		return FALSE;
	}

	return TRUE;
}

# user_create($user)
sub user_create {

	my $user = shift;

	# check if user already exists and can be created
	if (user_exists($user) == TRUE || user_can_create($user) == FALSE) {
		log_msg('info', "user '$user' already exists");

		return ERROR;
	}

	my $password = generate_random_string(32);
	my $home_dir = File::Spec::Unix->catdir(USER_ACCOUNT_PATH, $user);
	my $public_dir = File::Spec::Unix->catdir(USER_ACCOUNT_PATH, $user, USER_ACCOUNT_PUBLIC_DIR);

	# check home directory
	$home_dir =~ s/\.\.\///g;
	my $user_home_dir = USER_ACCOUNT_PATH;
	if ($home_dir !~ m/^$user_home_dir/) {
		return ERROR;
	}

	my $code = _user_create_generic($user, $user, SSH_JAIL_GROUP, $password, $home_dir, '/usr/sbin/nologin', USER_MIN_ID, USER_MAX_ID, USER_MIN_ID, USER_MAX_ID);
	# handle error
	if ($code == 0) {
		File::Path::make_path($home_dir, { user => 'root', group => 'root', mode => 0755 });
		File::Path::make_path($public_dir, { mode => 0755 }) && system("chown $user:$user $public_dir > /dev/null 2>&1");
		return $password;
	}
	else {
		return ERROR;
	}
}

# user_passwd_change($user, $old_password, $new_password)
sub user_passwd_change {

	my ($user, $old_password, $new_password) = @_;

	# check if user exists
	if (user_exists($user) == TRUE && user_is_disabled($user) == FALSE) {

		# generate hash from old password
		my $shadow = `cat /etc/shadow | grep $user`;
		$shadow = trim($shadow);
		my $pos = index($shadow, '$6$') + 3;
		my $len = index($shadow, '$', $pos) - $pos;
		my $salt = substr($shadow, index($shadow, '$6$') + 3, $len);
		my $hash = `mkpasswd -m sha-512 $old_password $salt`;
		$hash = quotemeta(trim($hash));

		# check if old password is valid
		if ($shadow =~ m/$hash/) {

			system("echo $user:$new_password | chpasswd SHA512 > /dev/null 2>&1");
			# handle error
			if ($? != 0) {
				handle_error($?);
			}
			else {
				log_msg('info', "password for '$user' changed");
				return SUCCESS;
			}

		}
		else {
			log_msg('info', "password for '$user' not changed - old password does not match");
		}
	}

	return ERROR;
}

# user_id($user)
sub user_id {

	my ($user) = @_;

	if (user_exists($user) == TRUE) {
		my $id = `id -u $user`;
		return trim($id);
	}

	return ERROR;
}

# user_disable($user)
sub user_disable {

	my ($user) = @_;

	if (user_exists($user) == TRUE) {
		# TODO
	}

	return ERROR;
}

# user_is_disabled($user)
sub user_is_disabled {

	my ($user) = @_;

	if (user_exists($user) == TRUE) {
		# TODO
	}

	return FALSE;
}

# user_remove($user)
sub user_remove {

	my ($user) = @_;

	if (user_exists($user) == TRUE) {
		my $code = _user_remove_generic($user);
		if ($code == 0) {
			return SUCCESS;
		}
	}

	return ERROR;
}

# user_get_list()
sub user_get_list {

	my @users;
	my @lines = `cat /etc/passwd`;
	foreach my $line (@lines) {
		$line = trim($line);
		my $user = substr($line, 0, index($line, ':'));
		my $id = `id -u $user`;
		if ($id >= USER_MIN_ID && $id <= USER_MAX_ID) {
			push(@users, $user);
		}
	}

	return @users;
}

1;
