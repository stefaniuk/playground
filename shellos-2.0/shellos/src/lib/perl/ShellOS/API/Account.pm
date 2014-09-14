package ShellOS::API::Account;

use strict;
use warnings;
use utf8;
use vars qw(@ISA);

##
## include
##

use ShellOS::API::User;
use ShellOS::Common;
use ShellOS::Config;

##
## constructor
##

@ISA = ('ShellOS::API::User');
sub new {

    my ($class, %args) = @_;
    my $self = bless({}, $class);

    return $self->_init(%args);
}

sub _init {

    my ($self, %args) = @_;

    # call parent "constructor"
    $self->ShellOS::API::User::_init(%args);

    return $self;
}

##
## public methods
##

# create()
sub create {

    # get arguments
    my ($self) = @_;

    print "ShellOS::API::Account::create\n";

    return $self->SUPER::create(@_);
}

# remove()
sub remove {

    # get arguments
    my ($self) = @_;

    print "ShellOS::API::Account::remove\n";

    return $self->SUPER::remove(@_);
}

1;

