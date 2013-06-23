# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# Copyright (C) 2008 - 2009 Nano-opt
# Licence: GPL

package ParseExop;

use strict;

use base qw(Exporter);

use MIME::Base64;
use Digest::SHA qw(sha1 sha1_base64);

%ParseExop::EXPORT = qw(
    ParseSSHA
    ParseHashed

    GetRandomSalt

    ExecSSHA
    ExecHash
);

sub ParseSSHA {
    my ($text) = @_;
    my $hash = {};
    if (length($text) == 32) {
        my $raw = MIME::Base64::decode_base64($text);
        $hash->{'salt'} = substr($raw, -4);
        $hash->{'sha1'} = substr($raw, 0, length($raw) - 4);
    }
    return $hash;
}

sub ParseHashed {
    my ($text) = @_;
    my $raw = MIME::Base64::decode_base64($text);
    my $hash = {};
    if ($raw =~ /^\{([A-Za-z]+)\}(.*)$/) {
        $hash->{'type'} = $1;
        $hash->{'data'} = $2;
    }
    return $hash;
}

sub GetRandomSalt {
    my ($len) = @_;
    if (! defined($len)) {$len = 4; }
    my $base = './0123456789';
    my $alpha = 'abcdefghijklmnopqrstuvwxyz';
    $base .= $alpha . uc($alpha);
    my $salt;
    for (1 .. $len) {
        $salt .= substr($base, int(rand(length($base))), 1);
    }
    return $salt;
}

sub ExecSSHA {
    my ($text, $salt) = @_;
    my $raw = $text . $salt;
    return sha1($raw) . $salt;
}

sub ExecHash {
    my ($type, $data) = @_;
    return '{' . uc($type) . '}' . MIME::Base64::encode_base64($data, '');
}

# --------------- private -------------


1;

__END__


