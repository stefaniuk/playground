package Host4ge::ServiceDiscovery;

use strict;
use warnings;
use utf8;

##
## include
##

use Host4ge::Common;
use Host4ge::Config;
use Module::Load;

##
## static variables
##

my $global_services;

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
    my @modules = (
        'Host4ge::Services::FTP',
        'Host4ge::Services::HTTPD'
    );
    if(!defined($global_services)) {
        foreach my $module (@modules) {
            load $module;
            load $module . '::Descriptor';
            my $service = $module->new();
            my $descriptor = ($module . '::Descriptor')->new(
                service => $service
            );
            my $name = $descriptor->get_service_name();
            $global_services->{$name} = {
                'service' => $service,
                'descriptor' => $descriptor
            };
        }
    }
    $self->{services} = $global_services;

    # set instance variables
    $self->{uid} = $args{uid};

    return $self;
}

##
## public methods
##

# get_service($service_name)
sub get_service {

    my ($self, $service_name) = @_;

    return $self->{services}->{$service_name}->{'service'};
}

# get_descriptor($service_name)
sub get_descriptor {

    my ($self, $service_name) = @_;

    return $self->{services}->{$service_name}->{'descriptor'};
}

# service_exists($service_name)
sub service_exists {

    my ($self, $service_name) = @_;

    if(exists $self->{services}->{$service_name}) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

# service_list()
sub service_list {

    my ($self) = @_;
    my @array = ();

    my $services = $self->{services};
    for my $service_name (keys %{$services}) {
        push(@array, $service_name);
    }
    @array = sort @array;

    return @array;
}

# service_help($service_name)
sub service_help {

    my ($self, $service_name) = @_;

    if($self->service_exists($service_name)) {
        my $descriptor = $self->get_descriptor($service_name);
        return $descriptor->service_help();
    }

    return FALSE;
}

# entity_exists($service_name, $entity)
sub entity_exists {

    my ($self, $service_name, $entity) = @_;

    if($self->service_exists($service_name)) {
        my $descriptor = $self->get_descriptor($service_name);
        return $descriptor->entity_exists($entity);
    }

    return FALSE;
}

# entity_list($service_name)
sub entity_list {

    my ($self, $service_name) = @_;

    if($self->service_exists($service_name)) {
        my $descriptor = $self->get_descriptor($service_name);
        return $descriptor->entity_list();
    }

    return FALSE;
}

# entity_help($service_name, $entity)
sub entity_help {

    my ($self, $service_name, $entity) = @_;

    if($self->entity_exists($service_name, $entity)) {
        my $descriptor = $self->get_descriptor($service_name);
        return $descriptor->entity_help($entity);
    }

    return FALSE;
}

# action_exists($service_name, $entity, $action)
sub action_exists {

    my ($self, $service_name, $entity, $action) = @_;

    if($self->entity_exists($service_name, $entity)) {
        my $descriptor = $self->get_descriptor($service_name);
        return $descriptor->action_exists($entity, $action);
    }

    return FALSE;
}

# action_list($service_name, $entity)
sub action_list {

    my ($self, $service_name, $entity) = @_;

    if($self->service_exists($service_name)) {
        my $descriptor = $self->get_descriptor($service_name);
        return $descriptor->action_list($entity);
    }

    return FALSE;
}

1;
