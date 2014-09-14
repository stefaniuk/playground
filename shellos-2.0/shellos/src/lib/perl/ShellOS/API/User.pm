package ShellOS::API::User;

use strict;
use warnings;
use utf8;

##
## include
##

use ShellOS::Common;
use ShellOS::Config;
use ShellOS::Filesystem;

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
    if(defined($args{user})) {
        $self->{user} = $args{user};
    }
    if(defined($args{group})) {
        $self->{group} = $args{group};
    }
    if(defined($args{groups})) {
        $self->{groups} = $args{groups};
    }
    if(defined($args{password})) {
        $self->{password} = $args{password};
    }
    if(defined($args{home})) {
        $self->{home} = $args{home};
    }

    return $self;
}

##
## private methods
##

# _chcek_by_id($uid, $gid)
sub _chcek_by_id {

    # get arguments
    my ($self, $uid, $gid) = @_;

    # get configuration options
    my $min_uid = $self->{conf}->get('USER_MIN_ID');
    my $max_uid = $self->{conf}->get('USER_MAX_ID');
    my $min_gid = $self->{conf}->get('GROUP_MIN_ID');
    my $max_gid = $self->{conf}->get('GROUP_MAX_ID');

    if($min_uid <= $uid && $uid <= $max_uid && $min_gid <= $gid && $gid <= $max_gid) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

# _chcek_by_user($user)
sub _chcek_by_user {

    # get arguments
    my ($self, $user) = @_;

    my $result = FALSE;
    open(FILE, "</etc/passwd");
    foreach my $line (<FILE>) {
        my ($username, $password, $uid, $gid, $home, $shell) = split(':', $line);
        # check username, uid and gid
        if($user eq $username && $self->_chcek_by_id($uid, $gid)) {
            $result = TRUE;
            last;
        }
    }
    close(FILE);

    return $result;
}

##
## public methods
##

# create()
sub create {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $user = $self->{user};
    my $group = $self->{group};
    my $groups = $self->{groups};
    my $password = $self->{password};
    my $home = $self->{home};

    # get configuration options
    my $shell = '/usr/sbin/nologin';
    my $min_uid = $self->{conf}->get('USER_MIN_ID');
    my $max_uid = $self->{conf}->get('USER_MAX_ID');
    my $min_gid = $self->{conf}->get('GROUP_MIN_ID');
    my $max_gid = $self->{conf}->get('GROUP_MAX_ID');

    if(!$self->exists($user)) {

        # sanitise home directory
        $home =~ s/\/\.+//g;
        $home =~ s/[\/]+/\//g;
        # check home directory location
        my $acc_dir = HOSTING_ACCOUNTS_DIR;
        my $app_dir = HOSTING_APPLICATIONS_DIR;
        my $dom_dir = HOSTING_DOMAINS_DIR;
        if($home !~ m/^($acc_dir|$app_dir|$dom_dir)\/[a-zA-Z0-9\/._-]+$/) {
            log_warn("user not created: cannot use '$home' as home directory");
            return FALSE;
        }
        # check if directory exists
        if(-d $home) {
            log_warn("user not created: directory '$home' already exists");
            return FALSE;
        }

        # fix groups
        if(defined($groups)) {
            $groups = "-G $groups";
        }
        else {
            $groups = '';
        }
        # fix password
        if(defined($password)) {
            $password = '-p `mkpasswd -m SHA-512 ' . $password . '`';
        }
        else {
            $password = '';
        }

        # create user
        system("groupadd $group -K GID_MIN=$min_gid -K GID_MAX=$max_gid > /dev/null 2>&1");
        system("useradd -K UID_MIN=$min_uid -K UID_MAX=$max_uid -d $home -s $shell $password -g $group $groups $user > /dev/null 2>&1");
        if($? != 0) {
            handle_error($?);
            return FALSE;
        }
        else {
            log_info("user '$user' created");
        }

        # create directories
        dir_create("$home", 'root', 'root', '0755');
        dir_create("$home/bin", 'root', 'root', '0755');
        dir_create("$home/home", 'root', 'root', '0755');
        dir_create("$home/home/$user", 'root', 'root', '1777');
        dir_create("$home/lib", 'root', 'root', '0755');
        dir_create("$home/sbin", 'root', 'root', '0755');
        dir_create("$home/tmp", 'root', 'root', '0755');
        dir_create("$home/usr/bin", 'root', 'root', '0755');
        dir_create("$home/usr/lib", 'root', 'root', '0755');
        dir_create("$home/usr/local", 'root', 'root', '0755');
        dir_create("$home/usr/sbin", 'root', 'root', '0755');
        dir_create("$home/var/log", 'root', 'root', '0755');
        dir_create("$home/home/$user/public", $user, $group, '0755');
        # use relative path for jailed user
        symlink_create_rel("$home/var", "./www", "../home/$user/public");

        return TRUE;
    }
    else {
        log_warn("user not created: user '$user' already exists");
        return FALSE;
    }
}

# remove()
sub remove {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $user = $self->{user};

    my $result = FALSE;
    open(FILE, "</etc/passwd");
    foreach my $line (<FILE>) {
        my ($username, $password, $uid, $gid, $home, $shell) = split(':', $line);
        # check username, uid and gid
        if($user eq $username && $self->_chcek_by_id($uid, $gid)) {

            # remove user
            system("userdel -fr $user > /dev/null 2>&1");
            if($? != 0 && ($? >> 8) != 12) { # 12 => userdel: warning: can't remove /var/mail/user: No such file or directory
                handle_error($?);
            }
            else {
                $result = TRUE;
            }

            last;
        }
    }
    close(FILE);

    if($result) {
        log_info("user '$user' removed");
    }
    else {
        log_warn("user not removed: user '$user' does not exist");
    }

    return $result;
}

# update($new_password)
sub update {

    # get arguments
    my ($self, $new_password) = @_;

    # get instance variables
    my $user = $self->{user};
    my $password = $self->{password};

    my $result = FALSE;
    if($self->_chcek_by_user($user)) {

        # generate hash from previous password
        my $shadow = `cat /etc/shadow | grep $user`;
        $shadow = trim($shadow);
        my $pos = index($shadow, '$6$') + 3;
        my $len = index($shadow, '$', $pos) - $pos;
        my $salt = substr($shadow, index($shadow, '$6$') + 3, $len);
        my $hash = `mkpasswd -m sha-512 $password $salt`;
        $hash = quotemeta(trim($hash));

        # check if previous password is valid
        if($shadow =~ m/$hash/) {

            system("echo $user:$new_password | chpasswd SHA512 > /dev/null 2>&1");
            # handle error
            if($? != 0) {
                handle_error($?);
            }
            else {
                log_info("password changed for user '$user'");
                $result = TRUE;
            }

        }
        else {
            log_warn("password not changed: previous password for user '$user' does not match");
        }
    }

    return $result;
}

# exists()
sub exists {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $user = $self->{user};

    if(getpwnam($user)) {
        return TRUE;
    }
    else {
        return FALSE;
    }
}

# list()
sub list {

    # get arguments
    my ($self) = @_;

    my @array = ();
    open(FILE, "</etc/passwd");
    foreach my $line (<FILE>) {
        my ($username, $password, $uid, $gid, $home, $shell) = split(':', $line);
        # check uid and gid
        if($self->_chcek_by_id($uid, $gid)) {
            push(@array, $username);
        }
    }
    close(FILE);
    @array = sort @array;

    return @array;
}

# count()
sub count {

    # get arguments
    my ($self) = @_;

    my @array = $self->list();

    return scalar(@array);
}

1;

