#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use vars qw/ %opt /;

##
## include
##

use ShellOS::API::HTTPD;
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
Usage: $script -s instance -t type -n name -i ip -d domain -p port -c config
    -s instance : httpd server instance name
    -t type     : virtual host type (account|application|domain)
    -n name     : virtual host configuration name
    -i ip       : IP address or *
    -d domain   : domain name
    -p port     : port
    -c config   : configuration options
    -h          : help
EOF
}

sub proceed {

    my $config = $opt{c};
    $config =~ s/\\n/\n/g;
    $config =~ s/\\t/    /g;

    my $httpd = new ShellOS::API::HTTPD('instance' => $opt{s});
    if($httpd->vhost_create($opt{t}, $opt{n}, $opt{i}, $opt{d}, $opt{p}, $config)) {
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

getopts('s:t:n:i:d:p:c:h', \%opt) or usage();
if($opt{h}) {
    usage();
}
elsif($opt{s} && $opt{t} && $opt{n} && $opt{i} && $opt{d} && $opt{p} && $opt{c}) {
    proceed();
}
else {
    usage();
}

exit 0;

