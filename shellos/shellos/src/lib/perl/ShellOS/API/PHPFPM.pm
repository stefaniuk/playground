package ShellOS::API::PHPFPM;

use strict;
use warnings;
use utf8;

##
## include
##

use ShellOS::Common;
use ShellOS::Config;

##
## constants
##

use constant NAME => 'php-fpm/default';

##
## static variables
##

my $global_conf;

##
## constructor
##

sub new {

    my ($class, %args) = @_;
    my $self = bless({}, $class);

    return $self->_init(%args);
}

sub _init {

    my ($self, %args) = @_;

    # set static variables
    if(!defined($global_conf)) {
        $global_conf = new ShellOS::Config();
    }
    $self->{conf} = $global_conf;

    # set instance variables
    if(defined($args{instance})) {
        $self->{instance} = $args{instance};
    }
    else {
        $self->{instance} = NAME;
    }

    return $self;
}

##
## administration methods
##

# start()
sub start {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};
}

# restart()
sub restart {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};
}

# reload()
sub reload {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};
}

# stop()
sub stop {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};
}

# is_running()
sub is_running {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};
}

# pool_create()
sub pool_create {

    # get arguments
    my ($self) = @_;

    # TODO
}

# pool_remove()
sub pool_remove {

    # get arguments
    my ($self) = @_;

    # TODO
}

# pool_update()
sub pool_update {

    # get arguments
    my ($self) = @_;

    # TODO
}

# pool_move()
sub pool_move {

    # get arguments
    my ($self) = @_;

    # TODO
}

# pool_exists()
sub pool_exists {

    # get arguments
    my ($self) = @_;

    # TODO
}

# pool_list()
sub pool_list {

    # get arguments
    my ($self) = @_;

    # TODO
}

# pool_count()
sub pool_count {

    # get arguments
    my ($self) = @_;

    # TODO
}

##
## help methods
##

# service_help()
sub service_help {

    # get arguments
    my ($self) = @_;

    # TODO

    return 'service_help';
}

# pool_help()
sub pool_help {

    # get arguments
    my ($self) = @_;

    # TODO

    return 'pool_help';
}

1;

