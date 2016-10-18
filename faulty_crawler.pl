#!/usr/bin/perl
# vim:ft=perl

# web crawler to search faulty links
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

# sudo apt-get update && sudo apt install -y cpanminus && sudo cpanm WWW::Mechanize && sudo cpanm WWW::UserAgent::Random

use strict;
use warnings;
use diagnostics;

if ( $#ARGV < 0 ) {
    print "URL?\n";
    exit 1;
}

use locale;

#use Data::Dumper;

use WWW::Mechanize;
use WWW::UserAgent::Random;

use List::MoreUtils qw(uniq);

use Term::ANSIColor qw(:constants);
$Term::ANSIColor::AUTORESET = 1;

my $mech = WWW::Mechanize->new( autocheck => 0 );
my $user_agent = rand_ua('windows');
$mech->agent($user_agent);
$mech->ssl_opts( verify_hostname => 0 );

my @queue;
my @referer;
my @def_uniq;
my $www = $ARGV[0];
$mech->get($www);
queue($www);

sub queue {
    my ($url) = @_;
    my @links = $mech->find_all_links();
    foreach my $link (@links) {
        if ((      $link->url() !~ /^http/
                && $link->url() !~ /^mailto/
                && $link->url() !~ /^#/
            )
            || $link->url() =~ /^$www/
            )
        {
            push( @queue, $link->url() );
            @queue = uniq(@queue);
            push( @referer, [ $url, $link->url ] );
        }
    }
}

foreach my $url (@queue) {
    my $res = $mech->get($url);
    if ( $res->is_success ) {

        #print BRIGHT_GREEN $mech->status() . ' ' . $mech->content_type() . ' ' . $url . "\n";

        #print BRIGHT_BLUE $res->decoded_content;
        #if ( $res->decoded_content =~ /file:\/\// ) {
        #    print BRIGHT_YELLOW $url . "\n";
        #}

        queue($url);
    }
    else {
        print BRIGHT_RED $mech->status() . ' ' . $url . "\n";
        foreach my $def (@referer) {
            if ( $def->[1] eq $url ) {
                if ( defined $def->[0] ) {
                    push( @def_uniq, $def->[0] );
                }
            }
        }
        @def_uniq = uniq(@def_uniq);
        foreach my $def_uniq_element (@def_uniq) {
            print BRIGHT_YELLOW $def_uniq_element . "\n";
        }
        @def_uniq = ();
    }
}

#print Dumper \@referer;
