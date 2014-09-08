#!/usr/bin/perl

use strict;
use warnings;

use Host4ge::Util;
use Host4ge::Common;

my ($account, $old_password, $new_password) = @ARGV;

if(account_passwd_change($account, $old_password, $new_password) == SUCCESS) {
	print "success\n";
}
else {
	print "error\n";
}
