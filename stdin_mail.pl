#!/usr/bin/perl
# vim:ft=perl

# stdin e-mail
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

# stdin is not empty so e-mail will be sent:
# echo -e "test1 test2 test3\ntest4 test5 test6" | perl stdin_mail.pl
# stdin is empty so e-mail will not be sent:
# touch test && cat test | perl stdin_mail.pl

use strict;
use warnings;
use diagnostics;

use Net::SMTP;
use Email::Date::Format qw(email_date);

my $from    = 'from@example.com';
my $to      = 'to@example.com';
my $subject = 'subject';
my $admin   = 'admin@example.com';
my $mailsrv = '127.0.0.1';

my $content = undef;
while ( defined( my $line = <> ) ) {
    $content .= $line;
}

if ( length($content) ) {
    my $smtp = Net::SMTP->new( $mailsrv, Debug => 4 );
    $smtp->mail($from);
    $smtp->to($to);
    $smtp->data();
    $smtp->datasend("From: Chuck Norris <$from>\n");
    $smtp->datasend("To: <$to>\n");
    my $maildate = email_date(time);
    $smtp->datasend("Date: $maildate\n");
    $smtp->datasend("Content-Type: text/plain\n");
    $smtp->datasend("Subject: $subject\n");
    $smtp->datasend("X-Priority: 1\n");
    #$smtp->datasend("X-OTRS-Priority: 4\n"); # X-OTRS-Priority: (1 very low|2 low|3 normal|4 high|5 very high)
    $smtp->datasend("Reply-To: $admin\n");
    $smtp->datasend("\n");
    $smtp->datasend($content);
    $smtp->dataend();
    $smtp->quit;
}
