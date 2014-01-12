#!/usr/bin/perl
# vim:ft=perl

# /etc/shadow parser
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

# perl stdin.pl < /etc/shadow
# user:root algorithm:SHA-512 salt:X hashed:X
# user:adam algorithm:SHA-512 salt:X hashed:X

use strict;
use warnings;

foreach my $line (<STDIN>) {
    chomp($line);
    my @shadow = split /:/, $line;
    if ( $shadow[1] =~ /^\$/ ) {
        my @col = split /\$/, $shadow[1];
        my $hash;
        if ( $col[1] eq 1 ) {
            $hash = 'MD5';
        }
        elsif ( $col[1] =~ /^2/ ) {    # "$2a$", "$2y$"
            $hash = 'Blowfish';
        }
        elsif ( $col[1] eq 5 ) {
            $hash = 'SHA-256';
        }
        elsif ( $col[1] eq 6 ) {
            $hash = 'SHA-512';
        }
        else {
            $hash = 'unknown';
        }
        print "user:"
            . $shadow[0]
            . " algorithm:"
            . $hash
            . " salt:"
            . $col[2]
            . " hashed:"
            . $col[3] . "\n";
    }
}
