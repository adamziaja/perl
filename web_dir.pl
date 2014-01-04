#!/usr/bin/perl -w
# vim:ft=perl

# HTTP Directory Brute Force Scanner
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use v5.10;
use strict;
use warnings;
use Set::CrossProduct;    # cpan[1]> install Set::CrossProduct
use LWP::UserAgent;
my $ua = LWP::UserAgent->new;

if ( $#ARGV < 2 ) {
    print "You must have at least 3 parameters (URL, min, max).\n";
    print "perl $0 http://google.com 2 8\n";
    exit 1;
}
my $target = $ARGV[0];
my $min    = $ARGV[1];    # min 2
if ( $min < 2 ) {
    $min = 2;
}
my $max = $ARGV[2];
my $set = [qw( a b c d e f g h i j k l m n o p q r s t u v w x y z )];

foreach my $length ( $min .. $max ) {
    my $cross = Set::CrossProduct->new( [ ($set) x $length ] );
    while ( my $tuple = $cross->get ) {
        my $string = join '', @$tuple;
        my $url    = $target . '/' . $string;
        my $req    = HTTP::Request->new( GET => $url );
        my $resp   = $ua->request($req);
        if ( $resp->is_success ) {
            print "$url\n";
            my $message = $resp->decoded_content;
            #print "Received reply: $message\n";
        }
        #else {
        #    print "$url\n";
        #    print "HTTP GET error code: ",    $resp->code,    "\n";
        #    print "HTTP GET error message: ", $resp->message, "\n";
        #}
    }
}
