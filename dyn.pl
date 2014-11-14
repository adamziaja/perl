#!/usr/bin/perl
# vim:ft=perl

# DynDNS auto activate
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

#use Data::Dumper;
#use MIME::QuotedPrint::Perl; # quoted-printable
use Net::IMAP::Simple;
use WWW::Mechanize;

my $imap = Net::IMAP::Simple->new(
    q(imap.gmail.com:993),
    use_ssl => 1,
    debug   => 0
);
$imap->login( 'login@gmail.com' => 'password' );

my @ids = $imap->search('SUBJECT "Your free Dyn hostname will expire"');

#print Dumper @ids;

my $mech = WWW::Mechanize->new();
$mech->agent(
    'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0'
);

foreach (@ids) {
    if ( !$imap->seen($_) ) {
        my $content = $imap->get($_);
        $content = "$content";
        #$content = decode_qp($content); # quoted-printable
        if ( $content =~ /Subject: Your free Dyn hostname will expire/ ) {
            if ( $content =~ m/(https:\/\/account.dyn.com(.*))/g ) {
                my $url = $1;
                print $url . "\n";
                my $response = $mech->get($url);
                if ( $response->is_success ) {
                    if ( $response->decoded_content
                        =~ /Your host confirmation has already been completed/g
                        )
                    {
                        print "OK\n";
                    }
                }
                else {
                    die $response->status_line . "\n";
                }
            }

            #$imap->unsee($_);
        }
    }
}

$imap->close;
