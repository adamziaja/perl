#!perl
# vim:ft=perl

# example of use URLQuery API v3
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

use WWW::Mechanize;
use JSON;
use Data::Dumper;

my $mech = WWW::Mechanize->new();
$mech->ssl_opts( verify_hostname => 0 );

my $res = $mech->post( 'https://_API-URL_/v3/json', # change me ("Please do not share this URL unless needed.")
    Content =>
        '{"method": "report_list", "key": "_YOUR-API-KEY_"}' # change me
);

if ( $res->is_success ) {
    my $urlquery = decode_json( $res->decoded_content );
    if ( $urlquery->{'_status_'}->{'status'} eq 'ok' ) {
        foreach my $report ( @{ $urlquery->{'reports'} } ) {
            if (   $report->{'url'}->{'ip'}->{'cc'} eq 'PL' # change me
                || $report->{'url'}->{'addr'} =~ /paypal/i ) # change me
            {
                print Dumper $report;
            }
        }
    }
}
else {
    die $res->status_line;
}
