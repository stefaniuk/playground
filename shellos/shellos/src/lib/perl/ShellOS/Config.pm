package ShellOS::Config;

use strict;
use warnings;
use utf8;
use base 'Exporter';

##
## include
##

use Config::Auto;

##
## constants
##

# directories
use constant INSTALL_DIR                    => $ENV{'INSTALL_DIR'};
use constant PROGRAMS_DIR                   => $ENV{'PROGRAMS_DIR'};
use constant SHELLOS_DIR                    => $ENV{'SHELLOS_DIR'};
use constant BIN_DIR                        => $ENV{'BIN_DIR'};
use constant CONF_DIR                       => $ENV{'CONF_DIR'};
use constant ETC_DIR                        => $ENV{'ETC_DIR'};
use constant JOB_DIR                        => $ENV{'JOB_DIR'};
use constant LIB_DIR                        => $ENV{'LIB_DIR'};
use constant LOG_DIR                        => $ENV{'LOG_DIR'};
use constant PKG_DIR                        => $ENV{'PKG_DIR'};
use constant SBIN_DIR                       => $ENV{'SBIN_DIR'};
# variable data directory
use constant VAR_DIR                        => $ENV{'VAR_DIR'};
# backup directories
use constant BACKUP_DIR                     => $ENV{'BACKUP_DIR'};
use constant BACKUP_DATABASES_DIR           => $ENV{'BACKUP_DATABASES_DIR'};
use constant BACKUP_LOGS_DIR                => $ENV{'BACKUP_LOGS_DIR'};
# cache directories
use constant CACHE_DIR                      => $ENV{'CACHE_DIR'};
use constant CACHE_DOWNLOADS_DIR            => $ENV{'CACHE_DOWNLOADS_DIR'};
use constant CACHE_IMAGES_DIR               => $ENV{'CACHE_IMAGES_DIR'};
use constant CACHE_KERNELS_DIR              => $ENV{'CACHE_KERNELS_DIR'};
use constant CACHE_PACKAGES_DIR             => $ENV{'CACHE_PACKAGES_DIR'};
use constant CACHE_UPDATES_DIR              => $ENV{'CACHE_UPDATES_DIR'};
# hosting directories
use constant HOSTING_DIR                    => $ENV{'HOSTING_DIR'};
use constant HOSTING_USER_RELATIVE_DIR      => $ENV{'HOSTING_USER_RELATIVE_DIR'};
use constant HOSTING_USER_DIR               => $ENV{'HOSTING_USER_DIR'};
use constant HOSTING_ACCOUNTS_DIR           => $ENV{'HOSTING_ACCOUNTS_DIR'};
use constant HOSTING_APPLICATIONS_DIR       => $ENV{'HOSTING_APPLICATIONS_DIR'};
use constant HOSTING_DOMAINS_DIR            => $ENV{'HOSTING_DOMAINS_DIR'};
use constant HOSTING_PUBLIC_RELATIVE_DIR    => $ENV{'HOSTING_PUBLIC_RELATIVE_DIR'};
use constant HOSTING_PUBLIC_DIR             => $ENV{'HOSTING_PUBLIC_DIR'};
# other directories
use constant CERTIFICATES_DIR               => $ENV{'CERTIFICATES_DIR'};
use constant FLAGS_DIR                      => $ENV{'FLAGS_DIR'};
use constant MAIL_DIR                       => $ENV{'MAIL_DIR'};
use constant TMP_DIR                        => $ENV{'TMP_DIR'};
use constant WORKSPACE_DIR                  => $ENV{'WORKSPACE_DIR'};
# files
use constant CONFIG_FILE                    => $ENV{'SHELLOS_CONF_FILE'};

##
## export
##

our @EXPORT = qw(

    INSTALL_DIR
    PROGRAMS_DIR
    SHELLOS_DIR
    BIN_DIR
    CONF_DIR
    ETC_DIR
    JOB_DIR
    LIB_DIR
    LOG_DIR
    PKG_DIR
    SBIN_DIR

    VAR_DIR

    BACKUP_DIR
    BACKUP_DATABASES_DIR
    BACKUP_LOGS_DIR

    CACHE_DIR
    CACHE_DOWNLOADS_DIR
    CACHE_IMAGES_DIR
    CACHE_KERNELS_DIR
    CACHE_PACKAGES_DIR
    CACHE_UPDATES_DIR

    HOSTING_DIR
    HOSTING_USER_RELATIVE_DIR
    HOSTING_USER_DIR
    HOSTING_ACCOUNTS_DIR
    HOSTING_APPLICATIONS_DIR
    HOSTING_DOMAINS_DIR
    HOSTING_PUBLIC_RELATIVE_DIR
    HOSTING_PUBLIC_DIR

    CERTIFICATES_DIR
    FLAGS_DIR
    MAIL_DIR
    TMP_DIR
    WORKSPACE_DIR

    CONFIG_FILE

);

##
## static variables
##

my $global_conf;

##
## constructor
##

sub new {

    my ($class, %args) = @_;
    my $self = bless({}, $class);

    return $self->_init(%args);
}

sub _init {

    my ($self, %args) = @_;

    # set static variables
    if(!defined($global_conf)) {
        $global_conf = (new Config::Auto(source => CONFIG_FILE))->parse();
    }
    $self->{conf} = $global_conf;

    return $self;
}

##
## public methods
##

# reload()
sub reload {

    my ($self) = @_;

    $global_conf = (new Config::Auto(source => CONFIG_FILE))->parse();
    $self->{conf} = $global_conf;

    return $self->{conf};
}

# get($name)
sub get {

    my ($self, $name) = @_;

    my $value = $self->{conf}->{$name};

    # if value is not defined in the config file
    # then get it from environment variable
    if(!defined($value)) {
        $value = $ENV{"$name"};
    }
    if(!defined($value)) {
        $name = lc($name);
        $value = $ENV{"$name"};
    }

    return $value;
}

1;

