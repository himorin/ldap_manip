#! /usr/bin/perl

use strict;
use NetLdap;
use Constants;
use LMConfig;
use Utils;
use ParseExop;
use Tmpl;
use ManipCGI;
use Checker;

my $uid = $ENV{'REMOTE_USER'};

my @disp_attr = ('cn', 'uidNumber', 'gidNumber', 'homeDirectory', 'mail',
  'modifyTimestamp', 'modifiersName', 'objectClass', 'maildrop', 'sn',
  'o', 'c', 'l', 'jpegPhoto',
  'bugmail', 'creatorsName', 'createTimestamp');

my $obj_tmpl = new Tmpl;
my $obj_cgi = new ManipCGI;
my $obj_checker = new Checker;
$obj_tmpl->set_vars('env', \%ENV);

my $obj_ldap = new NetLdap;
if (! $obj_ldap->bind) {
    $obj_tmpl->throw_error_code('ldap_bind_anonymous');
}
my $bdn = $obj_ldap->GetDNFromUID($uid);
if (! defined($bdn)) {
    $obj_tmpl->throw_error_code('ldap_get_dn');
}

my $user_attr = $obj_ldap->GetAttrsFromUID($uid, @disp_attr);

$obj_tmpl->set_vars("dn", $bdn);
$obj_tmpl->set_vars("uid", $ENV{'REMOTE_USER'});
$obj_tmpl->set_vars("entry", $user_attr);
$obj_tmpl->set_vars("groups", $obj_ldap->SearchMemberGroups($uid));

my $err;
# change attribute
if (($ENV{'REQUEST_METHOD'} eq 'POST') && defined($obj_cgi->param('upass'))) {
  my (%lrep, %ladd);
  if ($obj_cgi->param('new_sn') ne $obj_cgi->param('old_sn')) {
    if (defined($user_attr->{'sn'})) {
      $lrep{'sn'} = [ $obj_cgi->param('new_sn') ];
    } else {
      $ladd{'sn'} = [ $obj_cgi->param('new_sn') ];
    }
  }
  if ($obj_cgi->param('new_c') ne $obj_cgi->param('old_c')) {
    if (defined($user_attr->{'c'})) {
      $lrep{'c'} = [ $obj_cgi->param('new_c') ];
    } else {
      $ladd{'c'} = [ $obj_cgi->param('new_c') ];
    }
  }
  if ($obj_cgi->param('new_o') ne $obj_cgi->param('old_o')) {
    if (defined($user_attr->{'o'})) {
      $lrep{'o'} = [ $obj_cgi->param('new_o') ];
    } else {
      $ladd{'o'} = [ $obj_cgi->param('new_o') ];
    }
  }
  if ($obj_cgi->param('new_l') ne $obj_cgi->param('old_l')) {
    if (defined($user_attr->{'l'})) {
      $lrep{'l'} = [ $obj_cgi->param('new_l') ];
    } else {
      $ladd{'l'} = [ $obj_cgi->param('new_l') ];
    }
  }
  if (defined($obj_cgi->param('new_photo')) &&
      defined($obj_cgi->upload('new_photo'))) {
    my $pfh = $obj_cgi->upload('new_photo');
    my ($buf, $pdat);
    while (read($pfh, $buf, 1024)) {$pdat .= $buf; }
    if ((substr($pdat, 0, 2) ne "\xFF\xD8") ||
        (substr($pdat, 6, 4) ne "JFIF")) {
      $obj_tmpl->throw_error_user('image_not_jpeg');
    }
    if (length($pdat) > MAX_PHOTO_BYTE) {
      $obj_tmpl->throw_error_user('image_byte_too_large');
    }
    if (defined($user_attr->{'jpegPhoto'})) {
      $lrep{'jpegPhoto'} = [ $pdat ];
    } else {
      $ladd{'jpegPhoto'} = [ $pdat ];
    }
  }

  my $ldap = Net::LDAP->new(LDAP_URI);
  $err = $ldap->bind($bdn, password => $obj_cgi->param('upass'));
  if ($err->code) {
    $obj_tmpl->throw_error_user('pass_change_old_invalid');
  }
  if (keys(%lrep) > 0) {
    if (keys(%ladd) > 0) {
      $err = $ldap->modify($bdn, changes => [ replace => \%lrep, add => \%ladd ]);
    } else {
      $err = $ldap->modify($bdn, replace => \%lrep);
    }
  } elsif (keys(%ladd) > -1) {
    $err = $ldap->modify($bdn, add => \%ladd);
  } else {
    $obj_tmpl->throw_error_user('nothing_changed');
  }
  if ($err->code) {
    $obj_tmpl->throw_error_user('ldap_' . $err->code);
  }
  print $obj_cgi->redirect('view_status.cgi');
  exit;
};

# display form
print $obj_cgi->header();
$obj_tmpl->process('change_entry_form');

exit;

