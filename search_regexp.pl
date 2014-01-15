#!/usr/bin/perl
# vim:ft=perl

# search regexp in stdin
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

# perl search_regexp.pl < file
# echo "string" | perl search_regexp.pl

use strict;
use warnings;

while (<>) {
    my $regexp = '[0-9a-f]{32}';      # search md5
    my @matches = $_ =~ /$regexp/g;
    foreach (@matches) {
        print $_ . "\n";
    }
}
