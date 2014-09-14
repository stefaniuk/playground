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
    my $acc_dir = HOSTING_ACCOUNTS_DIR;
    my $app_dir = HOSTING_APPLICATIONS_DIR;
    my $dom_dir = HOSTING_DOMAINS_DIR;

    print STDOUT << "EOF";
Usage: $script -u user [-g group] [-G groups] [-p password] -d directory
    -u user      : user name
    -g group     : primary group
    -G groups    : additional groups
    -p password  : password
    -d directory : home directory, must be a subdirectory of $acc_dir, $app_dir or $dom_dir
    -h           : help
EOF
}

sub proceed {

    my $user = new ShellOS::API::User(
        'user' => $opt{u},
        'group' => $opt{g} ? $opt{g} : $opt{u},
        'groups' => $opt{G} ? $opt{G} : undef,
        'password' => $opt{p} ? $opt{p} : undef,
        'home' => $opt{d}
    );
    if($user->create()) {
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

getopts('u:g:G:p:d:h', \%opt) or usage();
if($opt{h}) {
    usage();
}
elsif($opt{u} && $opt{d}) {
    proceed();
}
else {
    usage();
}

exit 0;

