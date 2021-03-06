#!/usr/bin/perl

use strict;
use warnings;

use Sys::Syslog qw( :DEFAULT setlogsock );

my $type = shift;

setlogsock('unix');
openlog('httpd', 'ndelay', 'local4');
while (my $log = <STDIN>) {
    syslog($type, $log);
}
closelog();

exit 0;

