#!/usr/bin/perl
# vim:ft=perl

# parsing PhantomJS netsniff.js results for malicious software
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

# $ phantomjs netsniff.js http://adamziaja.com | perl phantomjs.pl
# 200 text/html http://adamziaja.com/
# http://adamziaja.com/ Scan request successfully queued, come back later for the report
# https://www.virustotal.com/url/77221285f45f3223d076dfe097669599daba4f9a86ab0a713be438236c4650b5/analysis/1391223729/
# 200 text/css http://fonts.googleapis.com/css?family=Nunito
# http://fonts.googleapis.com/css?family=Nunito Scan request successfully queued, come back later for the report
# https://www.virustotal.com/url/77fd78395513903241ef60c39aaa9f413c061f24b4ecc98beb94d2f355004a44/analysis/1391223730/

# PhantomJS you can download from http://phantomjs.org/download.html
# netsniff.js is in examples/netsniff.js
# you should also add on 104 line of netsniff.js following line:
# page.settings.userAgent = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0';

use strict;
use warnings;

use LWP::UserAgent;
my $ua = LWP::UserAgent->new;

use JSON::MaybeXS;

use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

my $stdin = decode_json do { local $/; <STDIN> };
foreach my $entrie ( @{ $stdin->{'log'}{'entries'} } ) {
    if ( $entrie->{'response'}->{'content'}->{'mimeType'} !~ /image\// ) {
        print BRIGHT_GREEN join ' ', $entrie->{'response'}->{'status'},
            $entrie->{'response'}->{'content'}->{'mimeType'},
            $entrie->{'request'}->{'url'} . "\n";

        my $res = $ua->post(
            'https://www.virustotal.com/vtapi/v2/url/scan',
            {   url => $entrie->{'request'}->{'url'},
                apikey =>
                    '_YOUR VIRUSTOTAL API KEY_',
            }
        );

        if ( $res->is_success ) {
            my $json = decode_json $res->decoded_content;
            print BRIGHT_BLUE join ' ', $json->{'resource'},
                $json->{'verbose_msg'} . "\n";
            print BRIGHT_RED $json->{'permalink'} . "\n";
        }
        else {
            die $res->status_line . "\n";
        }
    }
}
