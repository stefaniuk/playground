#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use vars qw/ %opt /;

##
## include
##

use Host4ge::API::User;
use Host4ge::Common;
use Host4ge::Config;

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

    my $user = new Host4ge::API::User(
        'user' => $opt{u}
    );
    if($user->remove()) {
        print "success\n";
    }
    else {
        print "error\n";
        exit -1;
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
