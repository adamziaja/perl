#!/usr/bin/perl
# vim:ft=perl

# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

# Skrypt sprawdza kiedy ostatni raz zostały zmodyfikowane pliki

use strict;
use warnings;
use diagnostics;
use Time::Seconds;
#use Term::ANSIColor qw(:constants);
#$Term::ANSIColor::AUTORESET = 1;

my @logs = </ugm/log/*>;
foreach my $log (@logs) {
    my $mtime = ( stat($log) )[9]; # http://stackoverflow.com/a/509666
    my $time = Time::Seconds->new( time - $mtime );
    my $days = int( $time->days );

    if ( $days <= 2 ) {
        #print BRIGHT_GREEN
        #print "Plik $log został zmodyfikowany $days dni temu.\n";
    }
    elsif ( $days < 7 ) {
        #print BRIGHT_YELLOW
        print "Plik $log został zmodyfikowany $days dni temu.\n";
    }
    else {
        #print BRIGHT_RED
        print "Plik $log został zmodyfikowany $days dni temu.\n";
    }
}
