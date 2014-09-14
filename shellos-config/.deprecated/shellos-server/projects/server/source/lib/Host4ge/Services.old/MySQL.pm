package Host4ge::Services::MySQL;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.1';

use Host4ge::Common;

# constructor
sub new {

	my ($class, %args) = @_;

	my $self = bless({}, $class);

	# set $instance
	$self->{instance} = exists $args{instance} ? $args{instance} : FPM_DEFAULT_INSTANCE;

	return $self;
}

# server_start()
sub server_start {

	my $self = shift;
}

# server_restart()
sub server_restart {

	my $self = shift;
}

# server_reload()
sub server_reload {

	my $self = shift;
}

# server_stop()
sub server_stop {

	my $self = shift;
}

# server_is_started()
sub server_is_started {

	my $self = shift;
}

1;
