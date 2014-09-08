package Host4ge::Apache;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.1';

our @EXPORT = qw(

	APACHE_DEFAULT_INSTANCE

	apache_exists
	apache_start
	apache_restart
	apache_reload
	apache_stop
	apache_is_running

	apache_vhost_exists
	apache_vhost_create
	apache_vhost_remove
	apache_vhost_get_list

);

use Host4ge::Util;
use Host4ge::Common;

use File::Slurp;

use constant APACHE_DEFAULT_INSTANCE => 'httpd';

# constructor
sub new {

	my ($class, %args) = @_;

	my $self = bless({}, $class);

	# set instance
	$self->{instance} = exists $args{instance} ? $args{instance} : APACHE_DEFAULT_INSTANCE;

	return $self;
}

# apache_exists()
sub apache_exists {

	my $self = shift;

	my $exec_file = INSTALL_DIR . "/$self->{instance}/bin/httpd";

	return -x $exec_file ? TRUE : FALSE
}

# apache_start()
sub apache_start {

	my $self = shift;

	my $apachectl = INSTALL_DIR . "/$self->{instance}/bin/apachectl";
	system("$apachectl -k start > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		handle_error($?);
		return ERROR;
	}
	else {
		log_msg('info', "Apache HTTPD Server instance '$self->{instance}' started successfully");
		return SUCCESS;
	}
}

# apache_restart()
sub apache_restart {

	my $self = shift;

	my $apachectl = INSTALL_DIR . "/$self->{instance}/bin/apachectl";
	system("$apachectl -k restart > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		handle_error($?);
		return ERROR;
	}
	else {
		log_msg('info', "Apache HTTPD Server instance '$self->{instance}' restarted successfully");
		return SUCCESS;
	}
}

# apache_reload()
sub apache_reload {

	my $self = shift;

	my $apachectl = INSTALL_DIR . "/$self->{instance}/bin/apachectl";
	system("$apachectl -k graceful > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		handle_error($?);
		return ERROR;
	}
	else {
		log_msg('info', "Apache HTTPD Server instance '$self->{instance}' reloaded successfully");
		return SUCCESS;
	}
}

# apache_stop()
sub apache_stop {

	my $self = shift;

	my $apachectl = INSTALL_DIR . "/$self->{instance}/bin/apachectl";
	system("$apachectl -k stop > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		handle_error($?);
		return ERROR;
	}
	else {
		log_msg('info', "Apache HTTPD Server instance '$self->{instance}' stopped successfully");
		return SUCCESS;
	}
}

# apache_is_running()
sub apache_is_running {

	my $self = shift;

	my $pid_file = INSTALL_DIR . "/$self->{instance}/log/httpd.pid";

	return -f $pid_file ? TRUE : FALSE
}

# apache_vhost_exists($user, $url, $port)
sub apache_vhost_exists {

	my $self = shift;
	my ($user, $url, $port) = @_;

	# check if apache instance and user user exist
	if (!$self->apache_exists() && !user_exists($user)) {
		return FALSE;
	}

	my $conf_file = INSTALL_DIR . "/$self->{instance}/conf/vhosts/$user.conf";
	if ( -f $conf_file && file_contains($conf_file, "<VirtualHost $url:$port>.*</VirtualHost>")) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

# apache_vhost_create($user, $url, $port)
sub apache_vhost_create {

	my $self = shift;
	my ($user, $url, $port) = @_;

	# check if vhost exists
	if ($self->apache_vhost_exists($user, $url, $port)) {
		return ERROR;
	}

	if (user_exists($user) == TRUE) {
		my $document_root = USER_ACCOUNT_PATH . "/$user/" . USER_ACCOUNT_PUBLIC_DIR;
		my $user_id = user_id($user);
		my $vhost = <<VHOST;
<VirtualHost $url:$port>
	Servername $url
	SuexecUserGroup $user $user
	DocumentRoot $document_root
	ProxyPass / fcgi://127.0.0.1:$user_id/
</VirtualHost>
VHOST

		my $config_file = INSTALL_DIR . "/$self->{instance}/conf/vhosts/$user.conf";
		File::Slurp::append_file($config_file, $vhost);

		return SUCCESS;
	}

	return ERROR;
}

# apache_vhost_remove($user, $url, $port)
sub apache_vhost_remove {

	my $self = shift;
	my ($user, $url, $port) = @_;

	# check if vhost exists
	if ($self->apache_vhost_exists($user, $url, $port)) {
		my $config_file = INSTALL_DIR . "/$self->{instance}/conf/vhosts/$user.conf";
		file_content_replace($config_file, "<VirtualHost $url:$port>.*</VirtualHost>\n", "");

		return SUCCESS;
	}

	return ERROR;
}

# apache_vhost_get_list()
sub apache_vhost_get_list {

	my $self = shift;

	# TODO
}

1;
