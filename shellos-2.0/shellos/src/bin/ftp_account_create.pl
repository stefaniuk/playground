#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use vars qw/ %opt /;

##
## include
##

use ShellOS::API::FTP;
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
Usage: $script -u user -p password -i id -d directory
    -u user      : virtual user name
    -p password  : virtual user password
    -i uid/gid   : system user/group id (chroot)
    -d directory : user directory
    -h           : help
EOF
}

sub proceed {

    my $ftp = new ShellOS::API::FTP();
    if($ftp->account_create($opt{u}, $opt{p}, $opt{i}, $opt{d})) {
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

getopts('u:p:i:d:h', \%opt) or usage();
if($opt{h}) {
    usage();
}
elsif($opt{u} && $opt{p} && $opt{i} && $opt{d}) {
    proceed();
}
else {
    usage();
}

exit 0;

