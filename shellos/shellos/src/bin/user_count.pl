#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use vars qw/ %opt /;

##
## include
##

use ShellOS::API::User;
use ShellOS::Common;
use ShellOS::Config;

use Getopt::Std;
use File::Basename;

##
## functions
##

sub usage() {

    my $script = basename($0);

    print STDOUT << "EOF";
Usage: $script
    -h : help
EOF
}

sub proceed {

    my $user = new ShellOS::API::User();
    print $user->count() . "\n";
}

##
## main
##

getopts('h', \%opt) or usage();
if($opt{h}) {
    usage();
}
else {
    proceed();
}

exit 0;

