#!/usr/bin/perl
# vim:ft=perl

# CIDR blocks by country
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

use LWP::UserAgent;

# cpan> install WWW::UserAgent::Random
use WWW::UserAgent::Random;
my $user_agent = rand_ua('browsers');

if ( !defined $ARGV[0] ) {
    print "You must have at least 1 parameter (country).\n";
    print "perl $0 ru\n";
    exit 1;
}

my $country = $ARGV[0];
$country =~ tr/A-Za-z/a-zA-Z/;

my $ua = LWP::UserAgent->new;
$ua->agent($user_agent);
my $res = $ua->post(
    'http://www.ip2location.com/free/visitor-blocker',
    {   'countryCode[]' => $country,
        format          => 'cidr',
        btnDownload     => 'Download',
    }
);

if ( $res->is_success ) {
    print $res->decoded_content;
}
else {
    die $res->status_line;
}
