package ShellOS::API::Whois;

use strict;
use warnings;
use utf8;

##
## include
##

use JSON;
use Net::Whois::Parser;

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

    # set instance variables
    if(defined($args{domain})) {
        $self->{domain} = $args{domain};
    }

    # get domain info
    $self->{info} = parse_whois(domain => $self->{domain});

    return $self;
}

# print_all()
sub print_all {

    # get arguments
    my ($self) = @_;

    if(defined $self->{info}) {
        print encode_json $self->{info};
    }
}

1;

