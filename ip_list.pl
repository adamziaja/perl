#!/usr/bin/perl
# vim:ft=perl

# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

=comment
changes the list of domains to the list of IPv4
- supports CNAME and round robin DNS
- ignore private network and localhost
- ~1000 domains / ~15 sec

$ cat hosts.txt 
www.google.com
www.yahoo.com
www.bing.com

$ perl ip_list.pl hosts.txt 
www.google.com 173.194.112.115
www.google.com 173.194.112.114
www.google.com 173.194.112.112
www.google.com 173.194.112.113
www.google.com 173.194.112.116
ds-any-fp3-real.wa1.b.yahoo.com 46.228.47.115
ds-any-fp3-real.wa1.b.yahoo.com 46.228.47.114
any.edge.bing.com 204.79.197.200

$ for host in $(cat hosts.txt);do host $host;done
www.google.com has address 173.194.113.18
www.google.com has address 173.194.113.19
www.google.com has address 173.194.113.20
www.google.com has address 173.194.113.17
www.google.com has address 173.194.113.16
www.google.com has IPv6 address 2a00:1450:4001:808::1014
www.yahoo.com is an alias for fd-fp3.wg1.b.yahoo.com.
fd-fp3.wg1.b.yahoo.com is an alias for ds-fp3.wg1.b.yahoo.com.
ds-fp3.wg1.b.yahoo.com is an alias for ds-any-fp3-lfb.wa1.b.yahoo.com.
ds-any-fp3-lfb.wa1.b.yahoo.com is an alias for ds-any-fp3-real.wa1.b.yahoo.com.
ds-any-fp3-real.wa1.b.yahoo.com has address 46.228.47.115
ds-any-fp3-real.wa1.b.yahoo.com has address 46.228.47.114
ds-any-fp3-real.wa1.b.yahoo.com has IPv6 address 2001:4998:f00b:1fe::3000
ds-any-fp3-real.wa1.b.yahoo.com has IPv6 address 2001:4998:f00b:1fe::3001
www.bing.com is an alias for any.edge.bing.com.
any.edge.bing.com has address 204.79.197.200

$ perl ip_list.pl hosts.txt | awk '{print $2}'
204.79.197.200
46.228.47.114
46.228.47.115
173.194.113.19
173.194.113.17
173.194.113.20
173.194.113.18
173.194.113.16
=cut

use strict;
use warnings;

use Net::DNS::Async;
my $dns = new Net::DNS::Async( QueueSize => 500, Retries => 2 );

use NetAddr::IP;

my $inv  = NetAddr::IP->new('0.0.0.0/8');
my $pn_a = NetAddr::IP->new('10.0.0.0/8');
my $pn_b = NetAddr::IP->new('172.16.0.0/12');
my $pn_c = NetAddr::IP->new('192.168.0.0/16');
my $lh   = NetAddr::IP->new('127.0.0.0/8');

foreach (@ARGV) {
    open my $input, $_ or die "Could not open $_: $!";

    foreach (<$input>) {
        chomp;
        $dns->add( \&cb, $_ );
    }
    $dns->await();

    sub cb {
        my $res = shift;
        if ($res) {
            foreach ( $res->answer ) {
                next unless $_->type eq 'A'; # this also works well with CNAME

                my $ip = NetAddr::IP->new( $_->address );

                if (   !$ip->within($inv)
                    && !$ip->within($pn_a)
                    && !$ip->within($pn_b)
                    && !$ip->within($pn_c)
                    && !$ip->within($lh) )
                {
                    print join( ' ', ( $_->name, $_->address . "\n" ) );
                }
            }
        }
    }
}
