#! /usr/bin/perl

use strict;

use NetLdap;
use Constants;
use LMConfig;
use Utils;
use ParseExop;
use Tmpl;
use ManipCGI;

my @disp_attr = (
  'cn', 'uidNumber', 'gidNumber', 'homeDirectory', 'mail',
  'modifyTimestamp', 'modifiersName', 'objectClass', 'maildrop', 'sn',
  'o', 'c', 'l', 'jpegPhoto',
  'creatorsName', 'createTimestamp',
);

my $obj_tmpl = new Tmpl;
my $obj_cgi = new ManipCGI;
my $user_name = $ENV{'REMOTE_USER'};
my $obj_ldap = new NetLdap;
if (! $obj_ldap->bind) {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_code('ldap_bind_anonymous');
}

my $user_dn = $obj_ldap->GetDNFromUID($user_name);
if (! defined($user_dn)) {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_code('ldap_get_dn');
}
my $user_attr = $obj_ldap->GetAttrsFromUID($user_name, @disp_attr);

$obj_tmpl->set_vars("dn", $user_dn);
$obj_tmpl->set_vars("uid", $ENV{'REMOTE_USER'});
$obj_tmpl->set_vars("entry", $user_attr);
$obj_tmpl->set_vars("groups", $obj_ldap->SearchMemberGroups($user_name));
$obj_tmpl->set_vars("photo_exist", defined($user_attr->{'jpegPhoto'}) ? 0 : 1);

print $obj_cgi->header();
$obj_tmpl->process('view_status');


exit;

