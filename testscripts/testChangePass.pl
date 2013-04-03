#! /usr/bin/perl

push(@INC, '../');

use strict;
use NetLdap;
use Constants;
use Utils;
use ParseExop;

my $uid = $ARGV[0];

my $obj_ldap = new NetLdap;
if (! $obj_ldap->bind) {
    print "Error in anonymous bind.\n";
    exit;
}
my $bdn = $obj_ldap->GetDNFromUID($uid);
if (! defined($bdn)) {
    print "Search uid = $uid failed.\n";
    exit;
}

my $oldpass = Utils::get_stdin("Password for $bdn");
my $newpass = Utils::get_stdin("New password");
my $ret = $obj_ldap->ChangePassword($bdn, $oldpass, $newpass);
print $ret . "\n";

exit;



