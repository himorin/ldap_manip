# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# Copyright (C) 2008 - 2009 Nano-opt
# Licence: GPL

package Tmpl;

use strict;

use base qw(Exporter);
use Template;

use Constants;
use Utils;

%Template::EXPORT = qw(
    new

    process
    get_default_type

    set_vars
    vars

    throw_error_code
    throw_error_user
);

our $conf_template;
our %hash_vars = {};

sub new {
    my ($self) = @_;

    $conf_template = {
        INCLUDE_PATH => Constants::LOCATIONS()->{'templates'},
        INTERPOLATE  => 1,
        POST_CHOMP   => 0,
        EVAL_PERL    => 1,
        COMPILE_DIR  => Constants::LOCATIONS()->{'compile_t'},
        PRE_PROCESS  => 'initialize.none.tmpl',
        ENCODING     => 'UTF-8',
        FILTERS      => {
            none       => \&Utils::filter_none,
            js         => \&Utils::filter_js,
            html_lb    => \&Utils::filter_html_lb,
            html_nb    => \&Utils::filter_html_nb,
            html       => \&Utils::filter_html,
            text       => \&Utils::filter_text,
            url_quote  => \&Utils::filter_url_quote,
        },
        CONSTANTS => _load_constants(),
        VARIABLES => {
        },
    };
#    $conf_template->{DEBUG} => 'parser, undef';
    return $self;
}

sub process {
    my ($self, $template, $type, $out) = @_;
    my $obj_template = Template->new($conf_template);
    if (defined($type) && ($type ne '')) {
        $template .= '.' . $type . '.tmpl';
    } else {
        $template .= '.' . $self->get_default_type() . '.tmpl';
    }
    my $ret = $obj_template->process($template, $self->vars(), $out);
    return $ret;
}

sub set_vars {
    my ($self, $name, $value) = @_;
    $hash_vars{$name} = $value;
}

sub vars {
    my ($self) = @_;
    return \%hash_vars;
}

sub get_default_type {
    my ($self) = @_;
    my $type = 'html';
    if (! Utils::exec_from_cgi()) {
        $type = 'txt';
    }
    return $type;
}

sub throw_error_code {
    my ($self, $err_id) = @_;
    $self->_throw_error('error/code', $err_id);
}

sub throw_error_user {
    my ($self, $err_id) = @_;
    $self->_throw_error('error/user', $err_id);
}

################################################################## PRIVATE

sub _throw_error {
    my ($self, $fname, $err_id) = @_;
    $self->set_vars('error', $err_id);
    $self->process($fname);
    exit;
}

sub _load_constants() {
    my %consts;
    foreach my $item (@Constants::EXPORT) {
        if (ref Constants->$item) {
            $consts{$item} = Constants->$item;
        } else {
            my @list = (Constants->$item);
            $consts{$item} = (scalar(@list) == 1) ? $list[0] : \@list;
        }
    }
    return \%consts;
}


1;

__END__

=head1 NAME
=head1 SYNOPSIS
=head1 DESCRIPTION
=head1 METHODS
=over 
=item C<>
=back


