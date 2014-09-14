package Host4ge::Services::FTP;

use strict;
use warnings;
use utf8;

##
## include
##

use Host4ge::Common;
use Host4ge::Config;

use DBI;

##
## constants
##

use constant NAME => 'ftp';

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
        $global_conf = new Host4ge::Config();
    }
    $self->{conf} = $global_conf;

    # set instance variables
    if(defined($args{instance})) {
        $self->{instance} = $args{instance};
    }
    else {
        $self->{instance} = NAME;
    }

    return $self;
}

##
## private methods
##

# _get_db_connection()
sub _get_db_connection {

    my ($self) = @_;

    if (!defined($self->{db})) {

        my $host = $self->{conf}->get('ftp_db_host');
        my $port = $self->{conf}->get('ftp_db_port');
        my $type = $self->{conf}->get('ftp_db_type');
        my $db = $self->{conf}->get('ftp_db_name');
        my $user = $self->{conf}->get('ftp_db_user');
        my $pass = $self->{conf}->get('ftp_db_pass');

        my $conn = DBI->connect("DBI:$type:$db:$host:$port", $user, $pass);
        $conn->{PrintError} = 0;

        $self->{db} = $conn;
    }

    return $self->{db};
}

# _get_user_id($user)
sub _get_user_id {

    my ($self, $user) = @_;

    my $db = _get_db_connection();

    my $sql = "SELECT id FROM users WHERE name=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $user);
    my $result = $stmt->execute();
    if (!$result) {
        return undef;
    }
    else {
        my @array = $stmt->fetchrow_array();
        return $array[0];
    }
}

# _get_user_group($user)
sub _get_user_group {

    my ($self, $user) = @_;

    my $db = _get_db_connection();

    my $sql = "SELECT name FROM groups WHERE user=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $user);
    my $result = $stmt->execute();
    if (!$result) {
        return undef;
    }
    else {
        my @array = $stmt->fetchrow_array();
        return $array[0];
    }
}

##
## administration methods
##

# start()
sub start {

    # get arguments
    my ($self) = @_;

    # TODO
}

# restart()
sub restart {

    # get arguments
    my ($self) = @_;

    # TODO
}

# reload()
sub reload {

    # get arguments
    my ($self) = @_;

    # TODO
}

# stop()
sub stop {

    # get arguments
    my ($self) = @_;

    # TODO
}

# is_running()
sub is_running {

    # get arguments
    my ($self) = @_;

    # TODO
}

##
## account methods
##

# account_create($user, $password, $group_name, $group_id, $id, $dir)
sub account_create {

    # get arguments
    my ($self, $user, $password, $group_name, $group_id, $id, $dir) = @_;

    my $db = _get_db_connection();

    # user
    my $sql = "INSERT INTO users (name, password, uid, gid, homedir, shell) VALUES (?, ?, ?, ?, ?, '/usr/sbin/nologin')";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $user);
    $stmt->bind_param(2, $password);
    $stmt->bind_param(3, $id);
    $stmt->bind_param(4, $id);
    $stmt->bind_param(5, $dir);
    my $result = $stmt->execute();
    if (!$result) {
        log_err("cannot create FTP user '$user'");
        return ERROR;
    }
    log_msg('info', "FTP user '$user' created");

    # group
    $sql = "INSERT INTO groups (name, gid, user) VALUES (?, ?, ?)";
    $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $group_name);
    $stmt->bind_param(2, $group_id);
    $stmt->bind_param(3, $user);
    $result = $stmt->execute();
    if (!$result) {
        log_err("cannot add FTP user '$user' to group '$group_name'");
        return ERROR;
    }
    log_msg('info', "FTP user '$user' added to group '$group_name'");

    return SUCCESS;
}

# account_remove()
sub account_remove {

    # get arguments
    my ($self) = @_;

    # TODO
}

# account_update()
sub account_update {

    # get arguments
    my ($self) = @_;

    # TODO
}

# account_exists()
sub account_exists {

    # get arguments
    my ($self) = @_;

    # TODO
}

# account_list()
sub account_list {

    # get arguments
    my ($self) = @_;

    # TODO
}

# account_count()
sub account_count {

    # get arguments
    my ($self) = @_;

    # TODO
}

##
## help methods
##

# service_help()
sub service_help {

    # get arguments
    my ($self) = @_;

    # TODO

    return 'service_help';
}

# account_help()
sub account_help {

    # get arguments
    my ($self) = @_;

    # TODO

    return 'account_help';
}

1;
