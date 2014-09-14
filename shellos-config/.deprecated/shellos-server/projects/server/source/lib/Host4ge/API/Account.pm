package Host4ge::API::Account;

use strict;
use warnings;
use utf8;
use vars qw(@ISA);

##
## include
##

use Host4ge::API::User;
use Host4ge::Common;
use Host4ge::Config;

##
## constructor
##

@ISA = ('Host4ge::API::User');
sub new {

    my ($class, %args) = @_;
    my $self = bless({}, $class);

    return $self->_init(%args);
}

sub _init {

    my ($self, %args) = @_;

    # call parent "constructor"
    $self->Host4ge::API::User::_init(%args);

    return $self;
}

##
## public methods
##

# create()
sub create {

    # get arguments
    my ($self) = @_;

    print "Host4ge::API::Account::create\n";

    return $self->SUPER::create(@_);
}

# remove()
sub remove {

    # get arguments
    my ($self) = @_;

    print "Host4ge::API::Account::remove\n";

    return $self->SUPER::remove(@_);
}

1;
