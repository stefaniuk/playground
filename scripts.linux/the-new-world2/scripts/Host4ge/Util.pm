package Host4ge::Util;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.1';

our @EXPORT = qw(

	FALSE
	TRUE
	ERROR
	SUCCESS

	SYSLOG_FACILITY
	SYSLOG_TAG

	log_msg
	handle_error
	is_error_code
	trim
	ltrim
	rtrim
	file_contains
	file_content_replace

);

use File::Slurp;
use Sys::Syslog;

# return codes
use constant FALSE => 0;
use constant TRUE => 1;
use constant ERROR => -1;
use constant SUCCESS => 255;

# syslog
use constant SYSLOG_FACILITY => 'local0';
use constant SYSLOG_TAG => 'host4ge';

# log_msg($type, $message)
sub log_msg {

	my $type = shift;
	my $message = shift;

	Sys::Syslog::setlogsock('unix');
	Sys::Syslog::openlog(SYSLOG_TAG, 'ndelay', SYSLOG_FACILITY);
	Sys::Syslog::syslog($type, $message);
	Sys::Syslog::closelog();
}

# handle_error($code)
sub handle_error {

	my $code = shift;
	my $whowasi = (caller(1))[3];

	if ($code == -1) {
		log_msg('err', "$whowasi failed to execute: $!");
		return -1;
	}
	elsif ($code & 127) {
		log_msg('err', "$whowasi died with signal " . ($code & 127) . ' ' . (($code & 128) ? 'with' : 'without') . ' coredump');
		return -1;
	}
	else {
		if ($code >> 8 != 0) {
			log_msg('err', "$whowasi exited with value " . ($code >> 8));
			return $code >> 8;
		}
	}
}

# is_error_code($value)
sub is_error_code {

	my $value = shift;

	return $value =~ /^-1$/ ? TRUE : FALSE;
}

# trim($string)
sub trim {

	my $string = shift;

	$string =~ s/^\s+//;
	$string =~ s/\s+$//;

	return $string;
}

# ltrim($string)
sub ltrim {

	my $string = shift;

	$string =~ s/^\s+//;

	return $string;
}

# rtrim($string)
sub rtrim {

	my $string = shift;

	$string =~ s/\s+$//;

	return $string;
}

# file_contains($file, $search)
sub file_contains {

	my ($file, $search) = @_;

	my $content = File::Slurp::read_file($file);

	if ($content =~ m/$search/s) {
		return TRUE;
	}
	else {
		return FALSE;
	}
}

# file_content_replace($file, $search, $replace)
sub file_content_replace {

	my ($file, $search, $replace) = @_;

	my $content = File::Slurp::read_file($file);
	$content =~ s/$search/$replace/s;
	File::Slurp::write_file($file, $content);
}

1;
