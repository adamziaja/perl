#!/usr/bin/perl
# vim:ft=perl

# check e-mail for activation
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

#use Data::Dumper;

use Net::IMAP::Simple;
use MIME::QuotedPrint::Perl;
use WWW::Mechanize;

my $imap = Net::IMAP::Simple->new(
    q(imap.gmail.com:993),
    use_ssl => 1,
    debug   => 0
);
$imap->login( 'XXXXX@gmail.com' => 'XXXXXXXXXX' ); # changeme

my @ids = $imap->search('SUBJECT "YYYYYYYYYYYYYYY"'); # changeme

#print Dumper @ids;

my $mech = WWW::Mechanize->new();
$mech->agent(
    'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)' # changeme
);

foreach (@ids) {
    if ( !$imap->seen($_) ) {
        my $content = $imap->get($_);
        $content = "$content";
        $content = decode_qp($content);
        if ( $content =~ /YYYYYYYYYYYYYYY/ ) { # changeme
            if ( $content =~ m#http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?#g ) {
                my $url = "http://YYYYYYYYYYYYYYY/" . $1; # changeme
                print $url . "\n";
                my $response = $mech->get($url);
                if ( $response->is_success ) {
                    if ( $response->decoded_content
                        =~ /YYYYY.YYYYY.YYYYY.YYYYY.YYYYY.YYYYY.YYYYY.YYYYY/g # changeme
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
