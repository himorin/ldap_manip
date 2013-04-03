# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# Constants definitions
#
# Copyright (C) 2008 - 2009 Nano-opt
# Licence: GPL

package Constants;

use strict;
use File::Basename;
use Cwd;

use base qw(Exporter);

@Constants::EXPORT = qw(
    URL_BASE
    LIB_VERSION
    LIB_NAME

    TRUE
    FALSE

    LDAP_URI
    LDAP_BASEDN

    LOCATIONS

    ERROR_SUCCESS
    ERROR_AUTH_PASS
    ERROR_LDAP

    PASS_DEGREE
);

# General
use constant URL_BASE     => '';
use constant LIB_VERSION  => '0.1';
use constant LIB_NAME     => 'LDAP Web-based User Manager';

use constant TRUE         => 1;
use constant FALSE        => 0;

# LDAP
use constant LDAP_URI     => '';
use constant LDAP_BASEDN  => '';

# ERROR
use constant ERROR_SUCCESS     => 0;
use constant ERROR_AUTH_PASS   => 1;
use constant ERROR_LDAP        => 2;

use constant PASS_DEGREE  => 7;

sub LOCATIONS {
    # absolute path for installation ("installation")
    my $path_base = dirname($INC{'Constants.pm'});
    # de-taint
    $path_base =~ /(.*)/;
    $path_base = $1;
    if ($path_base eq '.') {
       $path_base = getcwd();
    }
    my $path_data = $path_base . '/data';

    return {
        'base'            => $path_base,
        'cgi'             => $path_base,
        'data'            => $path_data,
        'templates'       => $path_base . '/template',
        'compile_t'       => $path_data . '/t',
    };
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

