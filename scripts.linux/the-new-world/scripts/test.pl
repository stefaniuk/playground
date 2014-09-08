#!/usr/bin/perl

use Host4ge::Utils;

my $utils = Host4ge::Utils;

$utils->replace('file', 'BEGIN.*END', 'new_text');
