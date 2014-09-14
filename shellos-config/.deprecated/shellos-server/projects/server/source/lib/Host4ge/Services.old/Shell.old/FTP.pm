package Host4ge::Shell::FTP;

use strict;
use warnings;
use utf8;

##
## include
##

use Host4ge::Common;

##
## constructor
##

sub new {

    my ($class, %args) = @_;
    my $self = bless({}, $class);

    return $self;
}

##
## methods
##

sub help {

    my ($self, @args) = @_;

	my $help = <<"HELP";
\033[1mHost4ge::Shell::FTP\033[0m

\033[1;32mSYNTAX\033[0m
    ftp add 
HELP

	return $help;
}

1;
