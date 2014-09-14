package ShellOS::API::HTTPD::Descriptor;

use strict;
use warnings;
use utf8;
use vars qw(@ISA);

##
## include
##

use ShellOS::Common;
use ShellOS::Config;
use ShellOS::ServiceDescriptor;

##
## constructor
##

@ISA = ('ShellOS::ServiceDescriptor');
sub new {

    my ($class, %args) = @_;
    my $self = bless({}, $class);

    return $self->_init(%args);
}

sub _init {

    my ($self, %args) = @_;

    # set instance variables
    my $name = ShellOS::API::HTTPD::NAME;
    my $methods = {
        'service' => {
            'start' => \&ShellOS::API::HTTPD::start,
            'restart' => \&ShellOS::API::HTTPD::restart,
            'reload' => \&ShellOS::API::HTTPD::reload,
            'stop' => \&ShellOS::API::HTTPD::stop,
            'running' => \&ShellOS::API::HTTPD::is_running,
            'help' => \&ShellOS::API::HTTPD::service_help
        },
        'vhost' => {
            'create' => \&ShellOS::API::HTTPD::vhost_create,
            'remove' => \&ShellOS::API::HTTPD::vhost_remove,
            'update' => \&ShellOS::API::HTTPD::vhost_update,
            'exists' => \&ShellOS::API::HTTPD::vhost_exists,
            'list' => \&ShellOS::API::HTTPD::vhost_list,
            'count' => \&ShellOS::API::HTTPD::vhost_count,
            'help' => \&ShellOS::API::HTTPD::vhost_help
        }
    };

    # call parent "constructor"
    $self->ShellOS::ServiceDescriptor::_init(
        name => $name,
        methods => $methods
    );

    return $self;
}

1;

