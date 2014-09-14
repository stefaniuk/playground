#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use vars qw/ %opt /;

##
## include
##

use Host4ge::API::Mail;
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
Usage: $script -m mial
    -m mail     : user e-mail address
    -p password : user password
    -h          : help
EOF
}

sub proceed {

    my $mail = new Host4ge::API::Mail();
    if($mail->account_create($opt{m}, $opt{p})) {
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

getopts('m:p:h', \%opt) or usage();
if($opt{h}) {
    usage();
}
elsif($opt{m} && $opt{p}) {
    proceed();
}
else {
    usage();
}

exit 0;
