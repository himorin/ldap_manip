#! /usr/bin/perl

use strict;

use NetLdap;
use Constants;
use Utils;
use ParseExop;

my @disp_attr = ('cn', 'uidNumber', 'gidNumber', 'homeDirectory', 'mail',
  'modifyTimestamp', 'modifiersName', 'objectClass', 'maildrop', 'sn',
  'bugmail');

my $user_name = $ARGV[0];
my $obj_ldap = new NetLdap;
if (! $obj_ldap->bind) {
  print "Failed bind\n";
  exit;
}

my $user_dn = $obj_ldap->GetDNFromUID($user_name);
if (! defined($user_dn)) {
  print "failed dn\n";
  exit;
}
my $user_attr = $obj_ldap->GetAttrsFromUID($user_name, @disp_attr);

my $tmp;
foreach (keys %$user_attr) {
  $tmp = $user_attr->{$_};
  if (defined($tmp)) {
    print "$_ : " . join(" / ", @$tmp) . "\n";
  } else {
    print "$_ : (undef)\n";
  }
}
print $user_attr->{modifyTimestamp} . "\n";

exit;



