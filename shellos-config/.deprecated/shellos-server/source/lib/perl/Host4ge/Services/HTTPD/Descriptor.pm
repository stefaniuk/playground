package Host4ge::Services::HTTPD::Descriptor;

use strict;
use warnings;
use utf8;
use vars qw(@ISA);

##
## include
##

use Host4ge::Common;
use Host4ge::Config;
use Host4ge::ServiceDescriptor;

##
## constructor
##

@ISA = ('Host4ge::ServiceDescriptor');
sub new {

    my ($class, %args) = @_;
    my $self = bless({}, $class);

    return $self->_init(%args);
}

sub _init {

    my ($self, %args) = @_;

    # set instance variables
    my $name = Host4ge::Services::HTTPD::NAME;
    my $methods = {
        'service' => {
            'start' => \&Host4ge::Services::HTTPD::start,
            'restart' => \&Host4ge::Services::HTTPD::restart,
            'reload' => \&Host4ge::Services::HTTPD::reload,
            'stop' => \&Host4ge::Services::HTTPD::stop,
            'running' => \&Host4ge::Services::HTTPD::is_running,
            'help' => \&Host4ge::Services::HTTPD::service_help
        },
        'vhost' => {
            'create' => \&Host4ge::Services::HTTPD::vhost_create,
            'remove' => \&Host4ge::Services::HTTPD::vhost_remove,
            'update' => \&Host4ge::Services::HTTPD::vhost_update,
            'exists' => \&Host4ge::Services::HTTPD::vhost_exists,
            'list' => \&Host4ge::Services::HTTPD::vhost_list,
            'count' => \&Host4ge::Services::HTTPD::vhost_count,
            'help' => \&Host4ge::Services::HTTPD::vhost_help
        }
    };

    # call parent "constructor"
    $self->Host4ge::ServiceDescriptor::_init(
        name => $name,
        methods => $methods
    );

    return $self;
}

1;
