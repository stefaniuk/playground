package Host4ge::Services::FTP::Descriptor;

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
    my $name = Host4ge::Services::FTP::NAME;
    my $methods = {
        'service' => {
            'start' => \&Host4ge::Services::FTP::start,
            'restart' => \&Host4ge::Services::FTP::restart,
            'reload' => \&Host4ge::Services::FTP::reload,
            'stop' => \&Host4ge::Services::FTP::stop,
            'running' => \&Host4ge::Services::FTP::is_running,
            'help' => \&Host4ge::Services::FTP::service_help
        },
        'account' => {
            'create' => \&Host4ge::Services::FTP::account_create,
            'remove' => \&Host4ge::Services::FTP::account_remove,
            'update' => \&Host4ge::Services::FTP::account_update,
            'exists' => \&Host4ge::Services::FTP::account_exists,
            'list' => \&Host4ge::Services::FTP::account_list,
            'count' => \&Host4ge::Services::FTP::account_count,
            'help' => \&Host4ge::Services::FTP::account_help
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
