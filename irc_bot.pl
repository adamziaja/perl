#!/usr/bin/perl
# vim:ft=perl

# IRC bot
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

use warnings;
use strict;

# apt-get install -y libemail-sender-perl
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;

sub alert {
    my ($body) = @_;
    my $email = Email::Simple->create(
        header => [
            To      => '<master@bot>',
            From    => '<irc@bot>',
            Subject => 'IRC',
        ],
        body => $body,
    );
    main::sendmail($email);
}

# apt-get remove --purge libbot-basicbot-perl
# apt-get install -y build-essential
# cpan> install Bot::BasicBot
package MyBot;
use base qw( Bot::BasicBot );

# wywoływane kiedy ktoś coś napisze w zasięgu bota
sub said {
    my ( $self, $message ) = @_;
    if ( $message->{body} =~ /\bperl\b/ ) {
        my $body = $message->{channel};
        $body .= " <" . $message->{who} . "> ";
        $body .= $message->{body} . "\n";
        main::alert($body);
    }
    return;
}

# wywoływane kiedy ktoś zostanie wykopany
sub kicked {
    my ( $self, $kicked ) = @_;
    # jeśli wykopany został bot
    if ( $self->nick eq $kicked->{kicked} ) {
        my $body = $kicked->{channel};
        $body .= " " . $kicked->{who};
        main::alert($body);
        $self->join( $kicked->{channel} );
    }
    return;
}

my $nick = 'bot';

MyBot->new(
    server   => 'irc.freenode.net',
    channels => ['#channel'],
    username => $nick,
    name     => $nick,
    nick     => $nick . $$,
    #alt_nicks => [ '', '' ],
)->run();
