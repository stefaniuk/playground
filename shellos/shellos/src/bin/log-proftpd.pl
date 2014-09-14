#!/usr/bin/perl

use strict;
use warnings;

use Sys::Syslog qw( :DEFAULT setlogsock );

open(my $fifo, '+< /srv/proftpd/log/proftpd-log.fifo');
while (<$fifo>) {
    setlogsock('unix');
    openlog('proftpd', 'ndelay', 'ftp');
    syslog('info', $_);
    closelog();
}
close($fifo);

exit 0;

