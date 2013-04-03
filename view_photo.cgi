#! /usr/bin/perl

use strict;

use NetLdap;
use Constants;
use Utils;
use ParseExop;
use Tmpl;
use ManipCGI;

use Data::Dumper;

my @disp_attr = (
  'cn', 'jpegPhoto',
);

my $obj_tmpl = new Tmpl;
my $obj_cgi = new ManipCGI;
my $user_name = $obj_cgi->param('uid');
my $obj_ldap = new NetLdap;
if (! $obj_ldap->bind) {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_code('ldap_bind_anonymous');
}

if (! defined($user_name)) {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_code('ldap_get_dn');
}
my $user_dn = $obj_ldap->GetDNFromUID($user_name);
if (! defined($user_dn)) {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_code('ldap_get_dn');
}
my $user_attr = $obj_ldap->GetAttrsFromUID($user_name, @disp_attr);
my $ent_photo = $user_attr->{'jpegPhoto'};

if (! defined($ent_photo)) {
    print $obj_cgi->header( -status => "404 Not found" );
    exit;
}

print $obj_cgi->header('image/jpeg');
print $ent_photo->[0];


exit;



