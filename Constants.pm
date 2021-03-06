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

use LMConfig;

use base qw(Exporter);

@Constants::EXPORT = qw(
    LIB_VERSION
    LIB_NAME

    TRUE
    FALSE

    LOCATIONS

    ERROR_SUCCESS
    ERROR_AUTH_PASS
    ERROR_LDAP
    ERROR_PASS_HISTORY
);

# General
use constant LIB_VERSION  => '0.1';
use constant LIB_NAME     => 'LDAP Web-based User Manager';

use constant TRUE         => 1;
use constant FALSE        => 0;

# LDAP

# ERROR
use constant ERROR_SUCCESS     => 0;
use constant ERROR_AUTH_PASS   => 1;
use constant ERROR_LDAP        => 2;
use constant ERROR_PASS_HISTORY => 3;

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

