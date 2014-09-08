#!/usr/bin/perl

use strict;
use warnings;

use Host4ge::Util;
use Host4ge::Common;

my ($account) = @ARGV;

my $password = account_create($account);
if(!is_error_code($password)) {
	print "$password\n";
}
else {
	print "error\n";
}
