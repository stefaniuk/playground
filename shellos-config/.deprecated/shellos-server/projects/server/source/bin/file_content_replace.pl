#!/usr/bin/perl

=comment

use strict;
use warnings;

use Host4ge::Common;

use Getopt::Std;
use File::Basename;

use vars qw/ %opt /;

sub usage() {

    my $script = basename($0);

    print STDERR << "EOF";
Usage: $script -s search -r replace -f file
    -s search  : search string
    -r replace : replace string
    -f file    : file
    -h         : help
EOF

    exit;
}

sub proceed {

    Host4ge::Common::file_content_replace($opt{f}, $opt{s}, $opt{r});
}

##
## main
##

getopts( 's:r:f:h', \%opt ) or usage();
if($opt{h}) {
    usage();
}
elsif($opt{s} && $opt{f}) {
    proceed();
}
else {
    usage();
}

=cut
