#! /usr/bin/perl

use strict;

use NetLdap;
use Constants;
use LMConfig;
use Utils;
use ParseExop;
use Tmpl;
use ManipCGI;

my $obj_tmpl = new Tmpl;
my $obj_cgi = new ManipCGI;
$obj_tmpl->set_vars('env', \%ENV);

print $obj_cgi->header();
$obj_tmpl->process('index');

exit;



