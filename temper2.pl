#!/usr/bin/perl
# vim:ft=perl
 
# TEMPer2
# (C) 2014 Adam Ziaja <adam@adamziaja.com> http://adamziaja.com
 
use strict;
use warnings;

use Device::USB::PCSensor::HidTEMPer;

my $pcsensor = Device::USB::PCSensor::HidTEMPer->new();
my @devices  = $pcsensor->list_devices();
  
foreach my $device ( @devices )
{
  print 'internal ' . $device->internal()->celsius() . "\n";
  print 'external ' . $device->external()->celsius() . "\n";
}
