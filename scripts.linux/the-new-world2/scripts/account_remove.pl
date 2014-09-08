#!/usr/bin/perl

use strict;
use warnings;

use Host4ge::Util;
use Host4ge::Common;

my ($account) = @ARGV;

if(account_remove($account) == SUCCESS) {
	print "success\n";
}
else {
	print "error\n";
}
