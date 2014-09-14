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
Usage: $script -u user
    -u user : user name
    -h      : help
EOF
}

sub proceed {

    my $user = new ShellOS::API::User(
        'user' => $opt{u}
    );
    if($user->exists()) {
        print "yes\n";
    }
    else {
        print "no\n";
    }
}

##
## main
##

getopts('u:h', \%opt) or usage();
if($opt{h}) {
    usage();
}
elsif($opt{u}) {
    proceed();
}
else {
    usage();
}

exit 0;

