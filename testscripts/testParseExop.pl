#! /usr/bin/perl

push(@INC, '../');

use strict;
use ParseExop;
use Utils;

use MIME::Base64;

my $hash;
my $input = $ARGV[0];

if ($input eq '') {
    print "No input.\n";
    exit;
}

$hash = ParseExop::ParseHashed($input);

print $hash->{'type'} . "\n";
print $hash->{'data'} . "\n";

$hash = ParseExop::ParseSSHA($hash->{'data'});

Utils::print_base64($hash->{'sha1'});
Utils::print_base64($hash->{'salt'});

my $pass = <STDIN>;
chomp($pass);

$pass = ParseExop::ExecSSHA($pass, $hash->{'salt'});
Utils::print_base64($pass);
print ParseExop::ExecHash('ssha', $pass) . "\n";

exit;

