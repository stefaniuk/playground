#!/usr/bin/perl

use strict;
use warnings;

use Host4ge::Util;
use Host4ge::Apache;

my ($instance, $account, $url, $port) = @ARGV;

my $apache = Host4ge::Apache->new( 'instance' => $instance );
if($apache->apache_vhost_create($account, $url, $port) == SUCCESS) {
	print "success\n";
}
else {
	print "error\n";
}
