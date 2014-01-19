#!/usr/bin/perl
# vim:ft=perl

# pcap generator
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

# sudo cpan install Net::PcapWriter
use Net::PcapWriter;

# sudo cpan install WWW::UserAgent::Random
use WWW::UserAgent::Random;

# sudo cpan install String::Random
use String::Random;
my $random = new String::Random;

# https://metacpan.org/pod/Net::PcapWriter
my $writer = Net::PcapWriter->new('test.pcap');

my $dst    = "www.az.gov";
my $dst_ip = "1.3.3.7";

my $n = 1;
while ( $n <= 1337 ) {
    my $ip_src = join( ".", map int rand 256, 1 .. 4 );
    my $conn = $writer->tcp_conn( $ip_src, rand(65535), $dst_ip, 80 );

    my $login          = $random->randpattern("ccccc");
    my $pass           = $random->randpattern("cCc!Ccnn");
    my $http_post_body = "login=$login&password=$pass";
    my $content_length = length($http_post_body);
    my $user_agent     = rand_ua('browsers');

    # this will automatically add syn..synack..ack handshake to pcap
    # each write will be a single packet
    $conn->write(
        0,
        "POST http://$dst/index.php?action=login HTTP/1.1
Host: $dst
Proxy-Connection: keep-alive
Content-Length: $content_length
Cache-Control: max-age=0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Origin: http://$dst
User-Agent: $user_agent
Content-Type: application/x-www-form-urlencoded
Referer: http://$dst
Accept-Encoding: sdch
Accept-Language: pl-PL,pl;q=0.8,en-US;q=0.6,en;q=0.4\r\n\r\n"
    );
    $conn->write( 0, "$http_post_body\r\n\r\n" );

    $conn->ack(1);    # force ack from server

    # client will no longer write
    $conn->shutdown(0);

    # this will automatically add ack to last packet
    $conn->write( 1, "HTTP/1.1 200 OK\r\nContent-length: 10\r\n\r\n" );
    $conn->write( 1, "success" );

    # will automatically add remaining FIN+ACK
    undef $conn;

    $n++;
}
