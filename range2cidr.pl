#!/usr/bin/perl
# vim:ft=perl

# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

# $ cat /tmp/ip.txt | perl range2cidr.pl
# 10.0.0.0/8
# 172.16.0.0/12
# 192.168.0.0/16
# $ cat /tmp/ip.txt
# 10.0.0.0-10.255.255.255
# 172.16.0.0-172.31.255.255
# 192.168.0.0-192.168.255.255

use strict;
use warnings;
use diagnostics;

use Net::CIDR;

while ( defined( my $line = <> ) ) {
    #print $line;
    print join("\n",Net::CIDR::range2cidr($line))."\n";
    #my @values = split('-', $line);
    #print "http://42.pl/netcalc/?a1=$values[0]&a2=$values[1]\n";
}
