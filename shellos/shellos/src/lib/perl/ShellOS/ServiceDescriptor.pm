package ShellOS::ServiceDescriptor;

use strict;
use warnings;
use utf8;

##
## include
##

use ShellOS::Common;
use ShellOS::Config;

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
    $self->{name} = $args{name};
    $self->{methods} = $args{methods};
    $self->{service} = $args{service};

    return $self;
}

##
## public methods
##

# get_service_name()
sub get_service_name {

    my ($self) = @_;

    return $self->{name};
}

# get_service_method($entity, $action)
sub get_service_method {

    my ($self, $entity, $action) = @_;

    if($self->action_exists($entity, $action)) {
        my $methods = $self->{methods};
        return $methods->{$entity}->{$action};
    }

    return FALSE;
}

# service_help()
sub service_help {

    my ($self) = @_;

    my $service = $self->{service};
    my $method = $self->get_service_method('service', 'help');
    my $result = $service->$method();

    return $result;
}

# entity_exists($entity)
sub entity_exists {

    my ($self, $entity) = @_;

    my $methods = $self->{methods};
    if(exists $methods->{$entity}) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

# entity_list()
sub entity_list {

    my ($self) = @_;
    my @array = ();

    my $methods = $self->{methods};
    for my $entity (keys %{$methods}) {
        push(@array, $entity);
    }
    @array = sort @array;

    return @array;
}

# entity_help($entity)
sub entity_help {

    my ($self, $entity) = @_;

    my $service = $self->{service};
    my $method = $self->get_service_method($entity, 'help');
    my $result = $service->$method();

    return $result;
}

# action_exists($entity, $action)
sub action_exists {

    my ($self, $entity, $action) = @_;

    my $methods = $self->{methods};
    if(exists $methods->{$entity} && exists $methods->{$entity}->{$action}) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

# action_list($entity)
sub action_list {

    my ($self, $entity) = @_;
    my @array = ();

    my $methods = $self->{methods};
    if(exists $methods->{$entity}) {
        for my $action (keys %{$methods->{$entity}}) {
            push(@array, $action);
        }
        @array = sort @array;
    }

    return @array;
}

1;

