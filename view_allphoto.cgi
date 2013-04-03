#! /usr/bin/perl

use strict;

use NetLdap;
use Constants;
use Utils;
use ParseExop;
use Tmpl;
use ManipCGI;

my @disp_attr = (
  'cn', 'mail', 'sn', 'uid',
  'o', 'c', 'l', 
);

my $obj_tmpl = new Tmpl;
my $obj_cgi = new ManipCGI;
my $obj_ldap = new NetLdap;
if (! $obj_ldap->bind) {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_code('ldap_bind_anonymous');
}
$obj_tmpl->set_vars("uid", $ENV{'REMOTE_USER'});

my %ulist;
foreach my $ucnt ($obj_ldap->GetAllUIDPhoto(@disp_attr)) {
    my %acnt = ();
    foreach (@disp_attr) {
        $acnt{$_} = $ucnt->get_value($_);
    }
    $ulist{$acnt{'uid'}} = \%acnt;
}
$obj_tmpl->set_vars("ulist", \%ulist);

print $obj_cgi->header();
$obj_tmpl->process('view_allphoto');

exit;



