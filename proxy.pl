#!/usr/bin/perl
# vim:ft=perl

# downloading web pages through a http proxy server
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

# cpan> install WWW::Mechanize LWP::Protocol::https
use WWW::Mechanize;

# cpan> install WWW::UserAgent::Random
use WWW::UserAgent::Random;
my $user_agent = rand_ua('windows');

if ( $#ARGV < 1 ) {
    print "You must have at least 2 parameters (url proxy).\n";
    print "perl $0 url proxy\n";
    exit 1;
}

my $url   = $ARGV[0];
my $proxy = $ARGV[1];

my $mech = WWW::Mechanize->new( onerror => undef );
$mech->agent($user_agent);
$mech->ssl_opts( verify_hostname => 0 );
$mech->timeout(5);
$mech->proxy( 'http', "http://$proxy" );

my $response = $mech->get($url);
if ( $response->is_success ) {
    print $response->decoded_content;
}

#else {
#    die $response->status_line;
#}
