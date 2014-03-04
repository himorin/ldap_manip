# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# Util routines
#
# Copyright (C) 2008 - 2009 Nano-opt
# Licence: GPL

package Utils;

use strict;

use base qw(Exporter);

use MIME::Base64;
use Encode;
use Constants;
use LMConfig;

%Utils::EXPORT = qw(
    print_base64
    get_stdin
    exec_from_cgi

    filter_none
    filter_js
    filter_html_lb
    filter_html_nb
    filter_html
    filter_text
    filter_url_quote
);

sub print_base64 {
    my ($text) = @_;
    print MIME::Base64::encode_base64($text, '') . "\n";
}

sub get_stdin {
    my ($text) = @_;
    print $text if ($text ne '');
    print ": ";
    my $value = <STDIN>;
    chomp($value);
    return $value;
}

sub exec_from_cgi {
    # SERVER_SOFTWARE is required to be defined for all by CGI spec
    return exists $ENV{'SERVER_SOFTWARE'} ? TRUE : FALSE;
}

# --------------- template_filters -------------

sub filter_none {
    return $_[0];
}

sub filter_js {
    my ($var) = @_;
    $var =~ s/([\\\'\"\/])/\\$1/g;
    $var =~ s/\n/\\n/g;
    $var =~ s/\r/\\r/g;
    $var =~ s/\@/\\x40/g; # anti-spam for email addresses
    return $var;
}

sub filter_html_lb {
    my ($var) = @_;
    $var =~ s/\r\n/\&#013;/g;
    $var =~ s/\n\r/\&#013;/g;
    $var =~ s/\r/\&#013;/g;
    $var =~ s/\n/\&#013;/g;
    return $var;
}

sub filter_html_nb {
    my ($var) = @_;
    $var =~ s/ /\&nbsp;/g;
    $var =~ s/-/\&#8209;/g;
    return $var ;
}

sub filter_html {
    my ($var) = Template::Filters::html_filter(@_);
    $var =~ s/\@/\&#64;/g;
    return $var;
}

sub filter_text {
    my ($var) = @_;
    $var =~ s/<[^>]*>//g;
    $var =~ s/\&#64;/@/g;
    $var =~ s/\&lt;/</g;
    $var =~ s/\&gt;/>/g;
    $var =~ s/\&quot;/\"/g;
    $var =~ s/\&amp;/\&/g;
    return $var;
}

sub filter_url_quote {
    my ($var) = @_;
    # IF utf8 mode, must utf8::encode 'var'
    $var =~ s/([^a-zA-Z0-9_\-.])/uc sprintf("%%%02x",ord($1))/eg;
    return $var;
}

# --------------- private -------------


1;

__END__

=head1 NAME
=head1 SYNOPSIS
=head1 DESCRIPTION
=head1 METHODS
=over 
=item C<>
=back


