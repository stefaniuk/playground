package ShellOS::API::Mail;

use strict;
use warnings;
use utf8;

##
## include
##

use ShellOS::Common;
use ShellOS::Config;

use DBI;

##
## constants
##

use constant NAME => 'mail';

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
        $global_conf = new ShellOS::Config();
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

    if(!defined($self->{db})) {

        my $host = $self->{conf}->get('mail_db_host');
        my $port = $self->{conf}->get('mail_db_port');
        my $type = $self->{conf}->get('mail_db_type');
        my $db = $self->{conf}->get('mail_db_name');
        my $user = $self->{conf}->get('mail_db_user');
        my $pass = $self->{conf}->get('mail_db_pass');

        my $conn = DBI->connect("DBI:$type:$db:$host:$port", $user, $pass);
        $conn->{PrintError} = 0;

        $self->{db} = $conn;
    }

    return $self->{db};
}

# _get_domain_id($domain)
sub _get_domain_id {

    # get arguments
    my ($self, $domain) = @_;

    my $db = $self->_get_db_connection();

    my $sql = "SELECT id FROM domains WHERE name=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $domain);
    my $result = $stmt->execute();
    if(!$result) {
        return undef;
    }
    else {
        my @array = $stmt->fetchrow_array();
        return $array[0];
    }
}

# _get_user_id($mail)
sub _get_user_id {

    # get arguments
    my ($self, $mail) = @_;

    my $db = $self->_get_db_connection();

    my $sql = "SELECT id FROM users WHERE email=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $mail);
    my $result = $stmt->execute();
    if(!$result) {
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

# account_create($mail, $password)
sub account_create {

    # get arguments
    my ($self, $mail, $password) = @_;
    my ($user, $domain) = split(/@/, $mail);

    # get database connection
    my $db = $self->_get_db_connection();

    # domain
    my $domain_id = $self->_get_domain_id($domain);
    if(!defined($domain_id)) {
        my $sql = "INSERT INTO domains (name) VALUES (?)";
        my $stmt = $db->prepare($sql);
        $stmt->bind_param(1, $domain);
        my $result = $stmt->execute();
        if(!$result) {
            #log_err("cannot create e-mail domain '$domain'");
            return FALSE;
        }
        $domain_id = $self->_get_domain_id($domain);
        #log_msg('info', "e-mail domain '$domain' created");
    }

    # user
    my $sql = "INSERT INTO users (domain_id, email, password) VALUES (?, ?, ?)";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $domain_id);
    $stmt->bind_param(2, $mail);
    $stmt->bind_param(3, $password);
    my $result = $stmt->execute();
    if(!$result) {
        #log_err("cannot create e-mail address '$mail'");
        return FALSE;
    }
    #log_msg('info', "e-mail address '$mail' created");

    return TRUE;
}

# account_remove($mail)
sub account_remove {

    # get arguments
    my ($self, $mail) = @_;
    my ($user, $domain) = split(/@/, $mail);

    # get database connection
    my $db = $self->_get_db_connection();

    # user
    my $sql = "DELETE FROM users WHERE email=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $mail);
    $stmt->execute();
    if($stmt->rows() == 0) {
        #log_err("e-mail address '$mail' does not exist");
        return FALSE;
    }
    #log_msg('info', "e-mail address '$mail' removed");

    # domain
    $sql = "DELETE FROM domains WHERE id NOT IN (SELECT distinct domain_id FROM users)";
    $stmt = $db->prepare($sql);
    $stmt->execute();
    if($stmt->rows() == 1) {
        #log_msg('info', "e-mail domain '$domain' removed");
    }

    return TRUE;
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

1;

