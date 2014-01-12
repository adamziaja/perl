#!/usr/bin/perl
# vim:ft=perl

# Logowanie na GG
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

if ( $#ARGV < 1 ) {
    print "Musisz podać dwa parametry - login hasło.\n";
    exit 1;
}

use LWP::UserAgent;

my $ua = LWP::UserAgent->new;
$ua->agent(
    'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36'
);

my $res = $ua->post(
    'https://login.gadu-gadu.pl/post',
    {   action   => 'Common_login',
        endpoint => 'www',
        uin      => $ARGV[0],
        password => $ARGV[1],
        submit   => '',
    }
);

if ( $res->is_success ) {
    my $content = $res->content;
    if ( $content =~ /nie\ poprawne\ dane\ logowania/i ) {
        print "Niepoprawne dane \"$ARGV[0]\":\"$ARGV[1]\"!\n";
    }
}
else {
    my $status_line = $res->status_line . "\n";
    if ( $status_line =~ /302\ Found/ ) {
        print "Poprawne dane \"$ARGV[0]\":\"$ARGV[1]\"!\n";
    }
    else {
        print $res->headers()->as_string;
    }
}
