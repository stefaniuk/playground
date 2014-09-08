#!/usr/bin/perl

use strict;
use warnings;

use Host4ge::Util;
use Host4ge::PHP;

my ($instance, $account) = @ARGV;

my $php = Host4ge::PHP->new( 'instance' => $instance );
if($php->fpm_pool_create($account) == SUCCESS) {
	print "success\n";
}
else {
	print "error\n";
}
