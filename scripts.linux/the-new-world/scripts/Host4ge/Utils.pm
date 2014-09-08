package Host4ge::Utils;

use File::Slurp;

use strict;
use warnings;

# replace(file, search, replace)
# 	search and replace text multi-line
sub replace {
	my $self = shift;
	if(@_) {
		my $file = shift;
		my $search = shift;
		my $replace = shift;
		my $file_contents = read_file $file;
		$file_contents =~ s/$search/$replace/s;
		write_file $file, $file_contents;
	}
}

1;
