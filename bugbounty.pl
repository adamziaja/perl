#!/usr/bin/perl
# vim:ft=perl

# bugbounty checker ;)
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

#  WWW::UserAgent::Random, WWW::Mechanize, LWP::Protocol::https
use WWW::Mechanize;
use WWW::UserAgent::Random;

use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

my $user_agent = rand_ua('windows');
my $mech       = WWW::Mechanize->new();
$mech->agent($user_agent);
$mech->ssl_opts( verify_hostname => 0 );

my $url = 'http://adamziaja.com';
$mech->get($url);
my @links = $mech->links();
foreach my $link (@links) {
    if ( defined( $link->url() ) && defined( $link->text() ) ) {
        if ( $link->url() eq $link->text() ) {
            my $bugbounty = $link->url();
            $mech->get($bugbounty);
            print $bugbounty . " - ";

            my $string = 'Adam Ziaja';
            if ( $mech->content =~ /$string/i ) {
                print BRIGHT_GREEN $string . ' ';
            }
            else {
                print BRIGHT_RED $string . ' ';
            }

            $string = 'adamziaja';
            if ( $mech->content =~ /$string/i ) {
                print BRIGHT_GREEN $string . "\n";
            }
            else {
                print BRIGHT_RED $string . "\n";
            }
        }
    }
}
