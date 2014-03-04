# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# Constants definitions
#
# Copyright (C) 2008 - 2009 Nano-opt
# Licence: GPL

package LMConfig;

use strict;

use base qw(Exporter);

@LMConfig::EXPORT = qw(
    URL_BASE

    LDAP_URI
    LDAP_BASEDN

    PASS_DEGREE
    MAX_PHOTO_BYTE

    HASH_HISTORY
);

use constant URL_BASE     => '';

use constant LDAP_URI     => '';
use constant LDAP_BASEDN  => '';

use constant PASS_DEGREE  => 7;

use constant MAX_PHOTO_BYTE => 51200;

use constant HASH_HISTORY => '';

__END__

=head1 NAME
=head1 SYNOPSIS
=head1 DESCRIPTION
=head1 METHODS
=over 
=item C<>
=back

