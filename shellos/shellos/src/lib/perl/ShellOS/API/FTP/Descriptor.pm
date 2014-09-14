package ShellOS::API::FTP::Descriptor;

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
    my $name = ShellOS::API::FTP::NAME;
    my $methods = {
        'service' => {
            'start' => \&ShellOS::API::FTP::start,
            'restart' => \&ShellOS::API::FTP::restart,
            'reload' => \&ShellOS::API::FTP::reload,
            'stop' => \&ShellOS::API::FTP::stop,
            'running' => \&ShellOS::API::FTP::is_running,
            'help' => \&ShellOS::API::FTP::service_help
        },
        'account' => {
            'create' => \&ShellOS::API::FTP::account_create,
            'remove' => \&ShellOS::API::FTP::account_remove,
            'update' => \&ShellOS::API::FTP::account_update,
            'exists' => \&ShellOS::API::FTP::account_exists,
            'list' => \&ShellOS::API::FTP::account_list,
            'count' => \&ShellOS::API::FTP::account_count,
            'help' => \&ShellOS::API::FTP::account_help
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

