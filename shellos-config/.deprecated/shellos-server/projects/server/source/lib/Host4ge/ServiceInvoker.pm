package Host4ge::ServiceInvoker;

use strict;
use warnings;
use utf8;

##
## include
##

use Host4ge::Common;
use Host4ge::Config;
use Host4ge::ServiceDiscovery;
use Host4ge::ServicePermissions;

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

    # create instance objects
    $self->{discovery} = new Host4ge::ServiceDiscovery(
        uid => $self->{uid}
    );
    $self->{permissions} = new Host4ge::ServicePermissions(
        uid => $self->{uid}
    );

    return $self;
}

##
## public methods
##

# call($service_name, $entity, $action, @args)
sub call {

    my ($self, $service_name, $entity, $action, @args) = @_;

    my $discovery = $self->{discovery};
    my $permissions = $self->{permissions};

    if($discovery->action_exists($service_name, $entity, $action) &&
            $permissions->has_permission($service_name, $entity, $action)) {

        my $service = $discovery->get_service($service_name);
        my $descriptor = $discovery->get_descriptor($service_name);
        my $method = $descriptor->get_service_method($entity, $action);

        my $result = $service->$method(@args);

        return $result;
    }
    elsif($discovery->service_exists($service_name) && $entity eq 'help') {
        return $discovery->service_help($service_name);
    }

    return undef;
}

# list()
sub list {

    my ($self) = @_;

    return $self->{discovery}->service_list();
}

1;
