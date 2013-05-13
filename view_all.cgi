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
  'o', 'c', 'l', 'jpegPhoto',
  'modifyTimestamp', 'modifiersName', 'createTimestamp',
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
foreach my $ucnt ($obj_ldap->GetAllUID(@disp_attr)) {
    my %acnt = ();
    foreach (@disp_attr) {
        $acnt{$_} = $ucnt->get_value($_);
    }
    $acnt{'photo_exist'} = defined($acnt{'jpegPhoto'}) ? 0 : 1;
    $ulist{$acnt{'uid'}} = \%acnt;
}
$obj_tmpl->set_vars("ulist", \%ulist);

my %glist;
foreach my $gcnt ($obj_ldap->GetAllGID('cn', 'memberUid')) {
    my %acnt = ();
    my @amem = ();
    my %hmem = ();
    $acnt{'cn'} = $gcnt->get_value('cn');
    @amem = $gcnt->get_value('memberUid');
    foreach (@amem) {$hmem{$_} = $_; }
    $acnt{'members'} = \%hmem;
    $acnt{'memberUid'} = \@amem;
    $glist{$acnt{'cn'}} = \%acnt;
}
$obj_tmpl->set_vars("glist", \%glist);

print $obj_cgi->header();
$obj_tmpl->process('view_all');

exit;



