package Host4ge::PHP;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.1';

our @EXPORT = qw(

	FPM_DEFAULT_INSTANCE

	fpm_get_instances
	fpm_pool_exists_any
	fpm_pool_remove_any
	fpm_pool_get_list
	fpm_set_version

	fpm_exists
	fpm_start
	fpm_restart
	fpm_reload
	fpm_stop
	fpm_is_running

	fpm_pool_exists
	fpm_pool_create
	fpm_pool_remove

);

use Host4ge::Util;
use Host4ge::Common;

use Config::IniFiles;
use File::Slurp;

use constant FPM_DEFAULT_INSTANCE => 'php-fpm-5.4';

# fpm_get_instances()
sub fpm_get_instances {

	my @instances;
	opendir(DIRHANDLE, INSTALL_DIR);
	while (my $dir = readdir(DIRHANDLE)) {
		if ($dir =~ m/^php-fpm-.*/s) {
			push(@instances, $dir);
		}
	}

	return @instances;
}

# fpm_pool_exists_any($pool)
sub fpm_pool_exists_any {

	my ($pool) = @_;

	my @instances = fpm_get_instances();
	foreach my $instance (@instances) {
		my $php = Host4ge::PHP->new( 'instance' => $instance );
		# check if pool exists
		if ($php->fpm_pool_exists($pool) == TRUE) {
			return TRUE;
		}
	}

	return FALSE;
}

# fpm_pool_remove_any($pool)
sub fpm_pool_remove_any {

	my ($pool) = @_;

	my $result = ERROR;
	my @instances = fpm_get_instances();
	foreach my $instance (@instances) {
		my $php = Host4ge::PHP->new( 'instance' => $instance );
		# check if pool exists
		if ($php->fpm_pool_exists($pool)) {
			my $config_file = INSTALL_DIR . "/$instance/conf/pools/$pool.conf";
			unlink($config_file);
			$result = SUCCESS;
		}
	}

	return $result;
}

# fpm_pool_get_list()
sub fpm_pool_get_list {

	# TODO
}

# fpm_pool_set($pool, $version)
sub fpm_set_version {

	my ($pool, $version) = @_;

	my $result = ERROR;
	my $instance = "php-fpm-$version";
	my $php = Host4ge::PHP->new( 'instance' => $instance );
	if ($php->fpm_exists() == TRUE) {
		fpm_pool_remove_any($pool);
		$result = $php->fpm_pool_create($pool);
	}

	return $result;
}

# constructor
sub new {

	my ($class, %args) = @_;

	my $self = bless({}, $class);

	# set $instance
	$self->{instance} = exists $args{instance} ? $args{instance} : FPM_DEFAULT_INSTANCE;

	return $self;
}

# fpm_exists()
sub fpm_exists {

	my $self = shift;

	my $exec_file = INSTALL_DIR . "/$self->{instance}/bin/php-fpm";

	return -x $exec_file ? TRUE : FALSE
}

# fpm_start()
sub fpm_start {

	my $self = shift;

	my $php_fpm = INSTALL_DIR . "/$self->{instance}/bin/php-fpm.sh";
	system("$php_fpm start > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		handle_error($?);
		return ERROR;
	}
	else {
		log_msg('info', "PHP FPM instance '$self->{instance}' started successfully");
		return SUCCESS;
	}
}

# fpm_restart()
sub fpm_restart {

	my $self = shift;

	my $php_fpm = INSTALL_DIR . "/$self->{instance}/bin/php-fpm.sh";
	system("$php_fpm restart > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		handle_error($?);
		return ERROR;
	}
	else {
		log_msg('info', "PHP FPM instance '$self->{instance}' restarted successfully");
		return SUCCESS;
	}
}

# fpm_reload()
sub fpm_reload {

	my $self = shift;

	my $php_fpm = INSTALL_DIR . "/$self->{instance}/bin/php-fpm.sh";
	system("$php_fpm reload > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		handle_error($?);
		return ERROR;
	}
	else {
		log_msg('info', "PHP FPM instance '$self->{instance}' reloaded successfully");
		return SUCCESS;
	}
}

# fpm_stop()
sub fpm_stop {

	my $self = shift;

	my $php_fpm = INSTALL_DIR . "/$self->{instance}/bin/php-fpm.sh";
	system("$php_fpm stop > /dev/null 2>&1");
	# handle error
	if ($? != 0) {
		handle_error($?);
		return ERROR;
	}
	else {
		log_msg('info', "PHP FPM instance '$self->{instance}' stopped successfully");
		return SUCCESS;
	}
}

# fpm_is_running()
sub fpm_is_running {

	my $self = shift;

	my $pid_file = INSTALL_DIR . "/$self->{instance}/log/php-fpm.pid";

	return -f $pid_file ? TRUE : FALSE
}

# fpm_pool_exists($pool)
sub fpm_pool_exists {

	my $self = shift;
	my ($pool) = @_;

	# check if php fpm instance exists
	if ($self->fpm_exists() == FALSE) {
		return FALSE;
	}

	my $conf_file = INSTALL_DIR . "/$self->{instance}/conf/pools/$pool.conf";
	if ( -f $conf_file && file_contains($conf_file, "[$pool]")) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

# fpm_pool_create($pool, $port)
sub fpm_pool_create {

	my $self = shift;
	my ($pool, $port) = @_;

	# check if pool exists
	my @instances = fpm_get_instances();
	if ($self->fpm_pool_exists($pool) == TRUE) {
		return ERROR;
	}

	my $user_account_path = USER_ACCOUNT_PATH;
	
	my $section = <<POOL;
[$pool]
	listen = $port
	listen.owner = $pool
	listen.group = $pool
	listen.mode = 0666
	user = $pool
	group = $pool
	pm = dynamic
	pm.max_children = 2
	pm.start_servers = 1
	pm.min_spare_servers = 1
	pm.max_spare_servers = 1
	pm.max_requests = 0
	pm.status_path = /$pool/status
	ping.path = /$pool/ping
	ping.response = pong
	chroot = $user_account_path/$pool/www/public/
	chdir = /
	catch_workers_output = yes
; end of $pool pool
POOL

	my $config_file = INSTALL_DIR . "/$self->{instance}/conf/pools/$pool.conf";
	File::Slurp::append_file($config_file, $section);

	return SUCCESS;
}

# fpm_pool_remove($user)
sub fpm_pool_remove {

	my $self = shift;
	my ($user) = @_;

	# check if pool exists
	if ($self->fpm_pool_exists($user) == TRUE) {
		my $config_file = INSTALL_DIR . "/$self->{instance}/conf/pools/$user.conf";
		unlink($config_file);

		return SUCCESS;
	}

	return ERROR;
}

1;
