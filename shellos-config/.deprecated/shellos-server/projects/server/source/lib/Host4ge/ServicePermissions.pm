package Host4ge::ServicePermissions;

use strict;
use warnings;
use utf8;

##
## include
##

use Host4ge::Common;
use Host4ge::Config;

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

    # set instance variables
    $self->{uid} = $args{uid};

    return $self;
}

##
## public methods
##

# has_permission($service, $entity, $action)
sub has_permission {

    my ($self, $service, $entity, $action) = @_;

    # TODO

    return TRUE;
}

1;
