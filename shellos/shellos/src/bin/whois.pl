#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use vars qw/ %opt /;

##
## include
##

use ShellOS::API::Whois;

use Getopt::Std;
use File::Basename;

##
## functions
##

sub usage() {

    my $script = basename($0);

    print STDOUT << "EOF";
Usage: $script -d domain
    -d : domain name
    -h : help
EOF
}

sub proceed {

    my $whois = new ShellOS::API::Whois(
        'domain' => $opt{d}
    );
    $whois->print_all();
}

##
## main
##

getopts('d:h', \%opt) or usage();
if($opt{h}) {
    usage();
}
elsif($opt{d}) {
    proceed();
}
else {
    usage();
}

exit 0;

