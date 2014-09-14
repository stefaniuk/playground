package Host4ge::Config;

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
use constant INSTALL_DIR                => '/srv';
use constant HOST4GE_DIR                => INSTALL_DIR . '/host4ge';
use constant BIN_DIR                    => HOST4GE_DIR . '/bin';
use constant CONF_DIR                   => HOST4GE_DIR . '/conf';
use constant LOG_DIR                    => HOST4GE_DIR . '/log';
# backup directories
use constant BACKUP_DIR                 => HOST4GE_DIR . '/var/backup';
use constant BACKUP_ACCOUNTS_DIR        => HOST4GE_DIR . '/var/backup/accounts';
use constant BACKUP_DATABASES_DIR       => HOST4GE_DIR . '/var/backup/databases';
use constant BACKUP_LOGS_DIR            => HOST4GE_DIR . '/var/backup/logs';
# cache directories
use constant CACHE_DIR                  => HOST4GE_DIR . '/var/cache';
use constant DOWNLOADS_DIR              => HOST4GE_DIR . '/var/cache/downloads';
use constant KERNELS_DIR                => HOST4GE_DIR . '/var/cache/kernels';
use constant PACKAGES_DIR               => HOST4GE_DIR . '/var/cache/packages';
use constant UPDATES_DIR                => HOST4GE_DIR . '/var/cache/updates';
# hosting directories
use constant HOSTING_DIR                => HOST4GE_DIR . '/var/hosting';
use constant HOSTING_ACCOUNTS_DIR       => HOST4GE_DIR . '/var/hosting/accounts';
use constant HOSTING_APPLICATIONS_DIR   => HOST4GE_DIR . '/var/hosting/applications';
# other directories
use constant CERTIFICATES_DIR           => HOST4GE_DIR . '/var/certificates';
use constant MAIL_DIR                   => HOST4GE_DIR . '/var/mail';
use constant TMP_DIR                    => HOST4GE_DIR . '/var/tmp';
use constant WWW_DIR                    => HOST4GE_DIR . '/var/www';
# files
use constant CONFIG_FILE                => CONF_DIR . '/host4ge.conf';

##
## export
##

our @EXPORT = qw(

    INSTALL_DIR
    HOST4GE_DIR
    BIN_DIR
    CONF_DIR
    LOG_DIR

    BACKUP_DIR
    BACKUP_ACCOUNTS_DIR
    BACKUP_DATABASES_DIR
    BACKUP_LOGS_DIR

    CACHE_DIR
    DOWNLOADS_DIR
    KERNELS_DIR
    PACKAGES_DIR
    UPDATES_DIR

    HOSTING_DIR
    HOSTING_ACCOUNTS_DIR
    HOSTING_APPLICATIONS_DIR

    CERTIFICATES_DIR
    MAIL_DIR
    TMP_DIR
    WWW_DIR

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

    return $self->{conf}->{$name};
}

1;
