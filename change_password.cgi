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

my $obj_tmpl = new Tmpl;
my $obj_cgi = new ManipCGI;
my $obj_checker = new Checker;
$obj_tmpl->set_vars('env', \%ENV);

my $obj_ldap = new NetLdap;
if (! $obj_ldap->bind) {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_code('ldap_bind_anonymous');
}
my $bdn = $obj_ldap->GetDNFromUID($uid);
if (! defined($bdn)) {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_code('ldap_get_dn');
}

my $err = '';
if ($ENV{'REQUEST_METHOD'} eq 'POST') {
  # password change mode
  if ($obj_cgi->param('new') ne $obj_cgi->param('new_conf')) {
    $err = 'pass_change_not_match';
  } elsif ($obj_checker->CheckStrength($obj_cgi->param('new')) < Constants->PASS_DEGREE) {
    $err = 'pass_change_not_strong';
  } else {
    $err = $obj_ldap->ChangePassword($bdn, $obj_cgi->param('old'),
      $obj_cgi->param('new'));
    if ($err == Constants->ERROR_AUTH_PASS) {
      $err = 'pass_change_old_invalid';
    } elsif ($err == Constants->ERROR_LDAP) {
      $err = 'pass_change_ldap_err';
    } elsif ($err == Constants->ERROR_PASS_HISTORY) {
      $err = 'pass_change_pass_history';
    } elsif ($err == Constants->ERROR_SUCCESS) {
      $err = '';
    } else {
      $err = 'pass_change_unknown_ldap';
    }
  }
  if ($err ne '') {
    print $obj_cgi->header();
    $obj_tmpl->throw_error_user($err);
  }
  print $obj_cgi->header();
  $obj_tmpl->process('change_password_changed');
  exit;
};

# display form
print $obj_cgi->header();
$obj_tmpl->process('change_password_form');

exit;



