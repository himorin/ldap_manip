#! /usr/bin/perl

push(@INC, '../');

use strict;
use NetLdap;
use Constants;
use Utils;

my $uid = $ARGV[0];
my $bdn = $ARGV[1];
my %opt;

my $obj_ldap = new NetLdap;
if ($bdn eq '') {
    print "Error in bind.\n" if (! $obj_ldap->bind);
} else {
    $opt{'password'} = Utils::get_stdin("Password for $bdn");
    print "Error in bind.\n" if (! $obj_ldap->bind($bdn, \%opt));
}

foreach my $entry ($obj_ldap->SearchUID($uid, '*', '+')) {
    $entry->dump;
    print "\n";
}

exit;

