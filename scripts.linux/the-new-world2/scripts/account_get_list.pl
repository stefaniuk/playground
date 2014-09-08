#!/usr/bin/perl

use strict;
use warnings;

use Host4ge::Common;

my @accounts = account_get_list();
foreach my $account (@accounts) {
	print "$account\n";
}
