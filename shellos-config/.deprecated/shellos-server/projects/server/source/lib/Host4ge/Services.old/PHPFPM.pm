package Host4ge::Services::PHPFPM;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.1';

use Host4ge::Common;
use Host4ge::User;

use Config::IniFiles;
use File::Basename;
use File::Find::Rule;
use File::Slurp;

# _get_instances_list()
sub _get_instances_list {

	sub preprocess { return sort {uc($a) cmp uc($b)} @_; }
	my @dirs = File::Find::Rule->directory
		->maxdepth(1)
		->name('php-fpm-*')
		->extras({ preprocess => \&preprocess })
		->in(INSTALL_DIR);

	my @instances;
	foreach my $dir (@dirs) {
		push(@instances, File::Basename::basename($dir));
	}

	return @instances;
}

# _get_user_pools($user)
sub _get_user_pools {

	my ($user) = @_;

	my %pools;
	foreach my $instance (_get_instances_list()) {
		my $conf_file = INSTALL_DIR . "/$instance/conf/accounts/$user.conf";
		if (-f $conf_file) {
			my %ini;
			tie %ini, 'Config::IniFiles', ( -file =>  $conf_file );
			while ((my $pool, my $config) = each %ini) {
				$pools{$pool}{'instance'} = $instance;
				$pools{$pool}{'config'} = $config;
			}
		}
	}

	return %pools;
}

# _get_all_data()
sub _get_all_data {

	my %data;
	foreach my $user (Host4ge::User::get_list()) {
		foreach my $instance (_get_instances_list()) {
		}
	}

	return %data;
}

# get_pools_list()
sub get_pools_list {

	my @list;

	# get all pools
	foreach my $user (Host4ge::User::get_list()) {
		my %pools = _get_user_pools($user);
		while ((my $pool, my $config) = each %pools) {
			push(@list, {
				'instance' => $pools{$pool}{'instance'},
				'user' => $user,
				'pool' => $pool
			})
		}
	}

	# sort the list
	@list = sort {
		$a->{instance} cmp $b->{instance} ||
		$a->{user} cmp $b->{user} ||
		$a->{pool} cmp $b->{pool}
	} @list;

	return @list;
}

# _get_available_port($user, %pools)
sub _get_available_port {

	my ($user, %pools) = @_;

	my $port;
	my $id = Host4ge::User::get_id($user);

	if (keys %pools) {

		# get all used ports
		my %ports;
		while ((my $pool, my $config) = each %pools) {
			$ports{$pools{$pool}{'config'}{'listen'}} = 1;
		}

		# find one that is available
		my $part = substr($id, 2, 3);
		for (my $i = PORT_USER_PREFIX_MIN; $i <= PORT_USER_PREFIX_MAX; $i++) {
			if (!exists($ports{$i . $part})) {
				$port = $i . $part;
				last;
			}
		}
	}
	else {

		# no ports used yet by this user
		$port = $id;

	}

	return $port;
}

# create_pool($instance, $user, $url)
sub create_pool {

	my ($instance, $user, $url) = @_;

	my $port = _get_available_port($user, _get_user_pools($user));
	my $dir = ACCOUNTS_DIR . "/$user/var/www/$url";
	$dir =~ s/\/\.+//g;

	my $pool = <<POOL;
[$user-$url]
	listen = $port
	listen.owner = $user
	listen.group = $user
	listen.mode = 0666
	user = $user
	group = $user
	pm = dynamic
	pm.max_children = 2
	pm.start_servers = 1
	pm.min_spare_servers = 1
	pm.max_spare_servers = 1
	pm.max_requests = 0
	pm.status_path = /$user/$url/status
	ping.path = /$user/$url/ping
	ping.response = pong
	chroot = $dir
	chdir = /
	catch_workers_output = yes
; end of "$user-$url" pool
POOL

	my $conf_file = INSTALL_DIR . "/$instance/conf/accounts/$user.conf";
	File::Slurp::append_file($conf_file, $pool);

	return SUCCESS;
}

1;
