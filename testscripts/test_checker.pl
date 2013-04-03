#! /usr/bin/perl

use Checker;

my $check = new Checker;

print "Check: " . $ARGV[0] . "\n";
print "Degree: " . $check->CheckStrength($ARGV[0]) . "\n";


exit;

