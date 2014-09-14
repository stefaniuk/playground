package Host4ge::API::HTTPD;

use strict;
use warnings;
use utf8;

##
## include
##

use Host4ge::Common;
use Host4ge::Config;

use File::Slurp;

##
## constants
##

use constant NAME => 'www';

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
## administration methods
##

# start()
sub start {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};

    my $apachectl = INSTALL_DIR . "/$instance/bin/apachectl";
    system("$apachectl -k start > /dev/null 2>&1");
    # handle error
    if($? != 0) {
        #handle_error($?);
        #return ERROR;
    }
    else {
        #log_msg('info', "Apache HTTPD Server instance '$instance' started successfully");
        #return SUCCESS;
    }
}

# restart()
sub restart {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};

    my $apachectl = INSTALL_DIR . "/$instance/bin/apachectl";
    system("$apachectl -k restart > /dev/null 2>&1");
    # handle error
    if($? != 0) {
        #handle_error($?);
        #return ERROR;
    }
    else {
        #log_msg('info', "Apache HTTPD Server instance '$instance' restarted successfully");
        #return SUCCESS;
    }
}

# reload()
sub reload {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};

    my $apachectl = INSTALL_DIR . "/$instance/bin/apachectl";
    system("$apachectl -k graceful > /dev/null 2>&1");
    # handle error
    if($? != 0) {
        #handle_error($?);
        #return ERROR;
    }
    else {
        #log_msg('info', "Apache HTTPD Server instance '$instance' reloaded successfully");
        #return SUCCESS;
    }
}

# stop()
sub stop {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};

    my $apachectl = INSTALL_DIR . "/$instance/bin/apachectl";
    system("$apachectl -k stop > /dev/null 2>&1");
    # handle error
    if($? != 0) {
        #handle_error($?);
        #return ERROR;
    }
    else {
        #log_msg('info', "Apache HTTPD Server instance '$instance' stopped successfully");
        #return SUCCESS;
    }
}

# is_running()
sub is_running {

    # get arguments
    my ($self) = @_;

    # get instance variables
    my $instance = $self->{instance};

    my $pid_file = INSTALL_DIR . "/$instance/log/httpd.pid";

    return -f $pid_file ? TRUE : FALSE
}

##
## account methods
##

# vhost_create($type, $name, $ip, $domain, $port, $config)
sub vhost_create {

    # get arguments
    my ($self, $type, $name, $ip, $domain, $port, $config) = @_;

    # get instance variables
    my $instance = $self->{instance};

    # ip
    my $ip_esc = $ip;
    if($ip eq '*') {
        $ip_esc = '[*]';
    }

    # check vhost type
    if($type !~ m/^(account|application)$/) {
        #log_err("cannot create vhost of type'$type'");
        return FALSE;
    }

    my $config_file = INSTALL_DIR . "/$instance/conf/${type}s/$name.conf";

    # check if vhost exists
    if(-f $config_file && file_contains($config_file, "# $domain:$port >>>\n<VirtualHost $ip_esc:$port>\n    ServerName $domain:$port\n.*\n</VirtualHost>\n# <<< $domain:$port\n")) {
        #log_err("cannot create vhost with name '$name'");
        return FALSE;
    }

    my $vhost = "# $domain:$port >>>\n<VirtualHost $ip:$port>\n    ServerName $domain:$port\n$config\n</VirtualHost>\n# <<< $domain:$port\n";
    File::Slurp::append_file($config_file, $vhost);

    return TRUE;
}

# vhost_remove($type, $name, $ip, $domain, $port)
sub vhost_remove {

    # get arguments
    my ($self, $type, $name, $ip, $domain, $port) = @_;

    # get instance variables
    my $instance = $self->{instance};

    # ip
    my $ip_esc = $ip;
    if($ip eq '*') {
        $ip_esc = '[*]';
    }

    my $config_file = INSTALL_DIR . "/$instance/conf/${type}s/$name.conf";

    # check if vhost exists
    if(-f $config_file && file_contains($config_file, "# $domain:$port >>>\n<VirtualHost $ip_esc:$port>\n    ServerName $domain:$port\n.*\n</VirtualHost>\n# <<< $domain:$port\n")) {
        file_content_replace($config_file, "# $domain:$port >>>\n<VirtualHost $ip_esc:$port>\n    ServerName $domain:$port\n.*\n</VirtualHost>\n# <<< $domain:$port\n", "");
        return TRUE;
    }

    return FALSE;
}

# vhost_update()
sub vhost_update {

    # get arguments
    my ($self) = @_;

    # TODO
}

# vhost_exists()
sub vhost_exists {

    # get arguments
    my ($self) = @_;

    # TODO
}

# vhost_list()
sub vhost_list {

    # get arguments
    my ($self) = @_;

    # TODO
}

# vhost_count()
sub vhost_count {

    # get arguments
    my ($self) = @_;

    # TODO
}

1;
