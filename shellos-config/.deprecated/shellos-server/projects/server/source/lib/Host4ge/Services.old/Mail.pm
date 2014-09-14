package Host4ge::Services::Mail;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.1';

use Host4ge::Config;
use Host4ge::Common;

use DBI;

use constant POSTFIX_DEFAULT_INSTANCE => 'postfix';
use constant DOVECOT_DEFAULT_INSTANCE => 'dovecot';

# constructor
sub new {

    my ($class, %args) = @_;

    my $self = bless({}, $class);

    # set postfix instance
    $self->{postfix} = exists $args{postfix} ? $args{postfix} : POSTFIX_DEFAULT_INSTANCE;
    # set dovecot instance
    $self->{dovecot} = exists $args{dovecot} ? $args{dovecot} : DOVECOT_DEFAULT_INSTANCE;

    return $self;
}

# start()
sub start {

    my $self = shift;

}

# restart()
sub restart {

    my $self = shift;

}

# reload()
sub reload {

    my $self = shift;

}

# stop()
sub stop {

    my $self = shift;

}

# is_running()
sub is_running {

    my $self = shift;

}

# _get_db_connection()
sub _get_db_connection {

    my $self = shift;

    if (!defined($self->{db})) {

        my $host = Host4ge::Config::DB_HOST;
        my $port = Host4ge::Config::DB_PORT;
        my $type = Host4ge::Config::DB_TYPE;

        my $db = Host4ge::Config::MAIL_DB_NAME;
        my $user = Host4ge::Config::MAIL_DB_USER;
        my $pass = Host4ge::Config::MAIL_DB_PASS;

        my $conn = DBI->connect("DBI:$type:$db:$host:$port", $user, $pass);
        $conn->{PrintError} = 0;

        $self->{db} = $conn;
    }

    return $self->{db};
}

# _get_domain_id($domain)
sub _get_domain_id {

    my $self = shift;
    my ($domain) = @_;

    my $db = _get_db_connection();

    my $sql = "SELECT id FROM domains WHERE name=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $domain);
    my $result = $stmt->execute();
    if (!$result) {
        return undef;
    }
    else {
        my @array = $stmt->fetchrow_array();
        return $array[0];
    }
}

# _get_user_id($email)
sub _get_user_id {

    my $self = shift;
    my ($email) = @_;

    my $db = _get_db_connection();

    my $sql = "SELECT id FROM users WHERE email=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $email);
    my $result = $stmt->execute();
    if (!$result) {
        return undef;
    }
    else {
        my @array = $stmt->fetchrow_array();
        return $array[0];
    }
}

# user_create($email)
sub user_create {

    my $self = shift;
    my ($email) = @_;
    my ($user, $domain) = split(/@/, $email);

    my $db = _get_db_connection();

    # domain
    my $domain_id = $self->_get_domain_id($domain);
    if (!defined($domain_id)) {
        my $sql = "INSERT INTO domains (name) VALUES (?)";
        my $stmt = $db->prepare($sql);
        $stmt->bind_param(1, $domain);
        my $result = $stmt->execute();
        if (!$result) {
            log_err("cannot create e-mail domain '$domain'");
            return ERROR;
        }
        $domain_id = $self->_get_domain_id($domain);
        log_msg('info', "e-mail domain '$domain' created");
    }

    # password
    my $password = generate_random_string(32);

    # user
    my $sql = "INSERT INTO users (domain_id, email, password) VALUES (?, ?, ?)";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $domain_id);
    $stmt->bind_param(2, $email);
    $stmt->bind_param(3, $password);
    my $result = $stmt->execute();
    if (!$result) {
        log_err("cannot create e-mail address '$email'");
        return ERROR;
    }
    log_msg('info', "e-mail address '$email' created");

    return $password;
}

# user_remove($email)
sub user_remove {

    my $self = shift;
    my ($email) = @_;
    my ($user, $domain) = split(/@/, $email);

    my $db = _get_db_connection();

    # user
    my $sql = "DELETE FROM users WHERE email=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $email);
    $stmt->execute();
    if ($stmt->rows() == 0) {
        log_err("e-mail address '$email' does not exist");
        return ERROR;
    }
    log_msg('info', "e-mail address '$email' removed");

    # domain
    $sql = "DELETE FROM domains WHERE id NOT IN (SELECT distinct domain_id FROM users)";
    $stmt = $db->prepare($sql);
    $stmt->execute();
    if ($stmt->rows() == 1) {
        log_msg('info', "e-mail domain '$domain' removed");
    }

    return SUCCESS;
}

# user_password_change($email, $old_password, $new_password)
sub user_password_change {

    my $self = shift;
    my ($email, $old_password, $new_password) = @_;

    my $db = _get_db_connection();

    my $sql = "UPDATE users SET password=? WHERE email=? and password=?";
    my $stmt = $db->prepare($sql);
    $stmt->bind_param(1, $new_password);
    $stmt->bind_param(2, $email);
    $stmt->bind_param(3, $old_password);
    $stmt->execute();
    if ($stmt->rows == 0) {
        log_err("e-mail password for '$email' user not changed");
        return ERROR;
    }
    log_msg('info', "e-mail password changed for '$email' user");

    return SUCCESS;
}

1;
