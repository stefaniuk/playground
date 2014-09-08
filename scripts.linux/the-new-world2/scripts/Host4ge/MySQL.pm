package Host4ge::MySQL;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.1';

our @EXPORT = qw(

	server_start
	server_restart
	server_reload
	server_stop
	server_is_started

);

use Host4ge::Util;
use Host4ge::Common;

# TODO: create constructor

# server_start($instance)
sub server_start {

	my ($instance) = @_;
}

# server_restart($instance)
sub server_restart {

	my ($instance) = @_;
}

# server_reload($instance)
sub server_reload {

	my ($instance) = @_;
}

# server_stop($instance)
sub server_stop {

	my ($instance) = @_;
}

# server_is_started($instance)
sub server_is_started {

	my ($instance) = @_;
}

1;
