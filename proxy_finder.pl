#!/usr/bin/perl
# vim:ft=perl

# proxy finder
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

# cpan> install WWW::Mechanize LWP::Protocol::https
use WWW::Mechanize;

# cpan> install WWW::UserAgent::Random
#use WWW::UserAgent::Random;
#my $user_agent = rand_ua('crawlers');

my $mech = WWW::Mechanize->new();
$mech->agent(
    'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0'
);
$mech->ssl_opts( verify_hostname => 0 );
$mech->timeout(15);

my $page = 1;
while ( $page <= 10 ) {
    my $url      = "http://www.proxylisty.com/ip-proxylist-$page";
    my $response = $mech->get($url);
    if ( $response->is_success ) {
        my $regexp
            = '<td>(\d.+)</td>\n<td><a href=\'http://www.proxylisty.com/port/(\d+)';
        my @matches = $response->decoded_content =~ /$regexp/g;
        foreach (@matches) {
            if ( $_ =~ '(\d+).(\d+).(\d+).(\d+)' ) {
                print $_ . ":";
            }
            else {
                print $_ . "\n";
            }
        }
        $page++;
    }
    else {
        die $response->status_line;
    }
}
