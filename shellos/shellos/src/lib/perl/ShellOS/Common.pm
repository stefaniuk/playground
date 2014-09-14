package ShellOS::Common;

use strict;
use warnings;
use utf8;
use base 'Exporter';

##
## include
##

use ShellOS::Config;

use File::Slurp;
use Sys::Syslog qw(:standard :macros setlogsock openlog syslog closelog);

##
## constants
##

use constant FALSE => 0;
use constant TRUE => 1;

##
## export
##

our @EXPORT = qw(

    FALSE
    TRUE

    log_info
    log_warn
    log_error
    handle_error
    is_error_code
    trim
    ltrim
    rtrim

    file_contains
    file_content_replace
    generate_random_string

);

##
## variables
##

my $conf;

##
## private static methods
##

# _getConf()
sub _getConf {

    if(!defined($conf)) {
        $conf = new ShellOS::Config();
    }

    return $conf;
}

# _log_msg($type, $message)
sub _log_msg {

    my $type = shift;
    my $message = shift;
    my $conf = _getConf();

    setlogsock('unix');
    openlog(
        $conf->get('SHELLOS_SYSLOG_TAG'),
        'ndelay',
        $conf->get('SHELLOS_SYSLOG_FACILITY'));
    syslog($type, $message);
    closelog();
}

##
## public static methods
##

# log_info($message)
sub log_info {

    my $message = shift;

    _log_msg(LOG_INFO, "$message");
}

# log_warn($message)
sub log_warn {

    my $message = shift;

    _log_msg(LOG_WARNING, "$message");
}

# log_error($message)
sub log_error {

    my $message = shift;
    my $whowasi = (caller(1))[3];

    _log_msg(LOG_ERR, "$whowasi $message");
}

# handle_error($code)
sub handle_error {

    my $code = shift;
    my $whowasi = (caller(1))[3];

    if ($code == -1) {
        _log_msg(LOG_ALERT, "$whowasi failed to execute: $!");
        return -1;
    }
    elsif ($code & 127) {
        _log_msg(LOG_ALERT, "$whowasi died with signal " . ($code & 127) . ' ' . (($code & 128) ? 'with' : 'without') . ' coredump');
        return -1;
    }
    else {
        if ($code >> 8 != 0) {
            _log_msg(LOG_ALERT, "$whowasi exited with value " . ($code >> 8));
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

# generate_random_string($length)
sub generate_random_string {

    my $length = shift;
    my @chars = ('a'..'z', 'A'..'Z', '0'..'9');
    my $random_string;

    foreach (1..$length) {
        $random_string .= $chars[rand @chars];
    }

    return $random_string;
}

1;

