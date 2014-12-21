#!/usr/bin/perl
# vim:ft=perl
 
# TEMPer2
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com

# # crontab -l | tail -1
# @hourly /usr/bin/perl /root/temper2.pl | head -1 >> /root/temper2.log 2>&1
# # /usr/bin/perl /root/temper2.pl | head -1 >> /root/temper2.log 2>&1
# # cat temper2.log
# 21-12-2014 19:03;26;23.5
 
use strict;
use warnings;

use POSIX qw(strftime);
use Device::USB::PCSensor::HidTEMPer;

my $datetime = strftime '%d-%m-%Y %H:%M', localtime;
print $datetime . ';';

my $pcsensor = Device::USB::PCSensor::HidTEMPer->new();
my @devices  = $pcsensor->list_devices();
  
foreach my $device ( @devices )
{
  print $device->internal()->celsius() . ';' . $device->external()->celsius() . "\n";
  print 'internal ' . $device->internal()->celsius() . "\n";
  print 'external ' . $device->external()->celsius() . "\n";
}
