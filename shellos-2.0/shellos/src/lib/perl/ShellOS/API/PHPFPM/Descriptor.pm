package ShellOS::API::PHPFPM::Descriptor;

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
    my $name = ShellOS::API::PHPFPM::NAME;
    my $methods = {
        'service' => {
            'start' => \&ShellOS::API::PHPFPM::start,
            'restart' => \&ShellOS::API::PHPFPM::restart,
            'reload' => \&ShellOS::API::PHPFPM::reload,
            'stop' => \&ShellOS::API::PHPFPM::stop,
            'running' => \&ShellOS::API::PHPFPM::is_running,
            'help' => \&ShellOS::API::PHPFPM::service_help
        },
        'pool' => {
            'create' => \&ShellOS::API::PHPFPM::pool_create,
            'remove' => \&ShellOS::API::PHPFPM::pool_remove,
            'update' => \&ShellOS::API::PHPFPM::pool_update,
            'move' => \&ShellOS::API::PHPFPM::pool_move,
            'exists' => \&ShellOS::API::PHPFPM::pool_exists,
            'list' => \&ShellOS::API::PHPFPM::pool_list,
            'count' => \&ShellOS::API::PHPFPM::pool_count,
            'help' => \&ShellOS::API::PHPFPM::pool_help
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

