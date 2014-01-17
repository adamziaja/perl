#!/usr/bin/perl
# vim:ft=perl

# wyszukiwanie danego ciągu znaków na stronach internetowych w danej klasie CIDR
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

if ( $#ARGV < 1 ) {
    print "Musisz podać dwa parametry - CIDR string.\n";
    exit 1;
}
else {
    print 'Szukam ciągu znaków ' . $ARGV[1] . ' w ' . $ARGV[0] . "\n";
}

# cpan> install LWP::Parallel::UserAgent
use LWP::Parallel::UserAgent;
use HTTP::Request;

# cpan> install NetAddr::IP
use NetAddr::IP;

my @cidr = ( $ARGV[0] );

my $reqs;
for my $cidr (@cidr) {
    my $n = NetAddr::IP->new($cidr);
    for my $ip ( @{ $n->hostenumref } ) {
        push @$reqs, HTTP::Request->new( 'GET', 'http://' . $ip->addr );
        push @$reqs, HTTP::Request->new( 'GET', 'https://' . $ip->addr );
    }
}

my $pua = LWP::Parallel::UserAgent->new();
$pua->in_order(0);      # handle requests in order of registration
$pua->duplicates(0);    # ignore duplicates
$pua->timeout(2);       # in seconds
$pua->redirect(1);      # follow redirects

foreach my $req (@$reqs) {
    print "Dodaję do kolejki '" . $req->url . "'\n";
    if ( my $res = $pua->register($req) ) {
        print STDERR $res->error_as_HTML;
    }
}
my $entries = $pua->wait();

foreach ( keys %$entries ) {
    my $res = $entries->{$_}->response;

    print $res->request->url . ' ' . $res->code . "\n";

    if ( $res->is_success ) {
        my $content = $res->content;
        if ( $content =~ /$ARGV[1]/i ) {
            print "Znalazłem ciąg znaków "
                . $ARGV[1] . " na "
                . $res->request->url . "\n";
        }
    }
}
