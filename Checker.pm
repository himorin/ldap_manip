# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# Password strength checker
#
# Licence: GPL

package Checker;

use strict;

use base qw(Exporter);
%Checker::EXPORT = qw(
  new
  CheckStrength
);

sub new {
  my ($self) = @_;
  return $self;
}

# Return strength parameter
#   * +1 : Length is longer than 8 chars
#   * +1 : Contains one char for each charactor class
#   * +2 : Contains more than two chars for each charactor class
#   * +1 : Contains more than two different chars in 'other' class
#   * +1 : More than three words (or contains more than two spaces)
#   * +2 : More than five words (or contains more than four spaces)
sub CheckStrength {
  my ($self, $password) = @_;
  my $degree = 0;
  my @chars = split(//, $password);
  my %class;
  if ($#chars >= 7) {$degree += 1; }
  foreach (@chars) {
    if ($_ =~ /[a-z]/) {
      if (defined($class{alpha})) {$class{alpha} += 1; }
      else {$class{alpha} = 1; }
    } elsif ($_ =~ /[A-Z]/) {
      if (defined($class{ALPHA})) {$class{ALPHA} += 1; }
      else {$class{ALPHA} = 1; }
    } elsif ($_ =~ /\d/) {
      if (defined($class{num})) {$class{num} += 1; }
      else {$class{num} = 1; }
    } elsif ($_ =~ /\s/) {
      if (defined($class{sp})) {$class{sp} += 1; }
      else {$class{sp} = 1; }
    } else {
      if (defined($class{other})) {$class{other} += 1; }
      else {$class{other} = 1; }
      if (defined($class{$_})) {$class{$_} += 1; }
      else {$class{$_} = 1; }
    }
  }

  $degree += $self->CheckClass(\%class, 'alpha', 1);
  $degree += $self->CheckClass(\%class, 'ALPHA', 1);
  $degree += $self->CheckClass(\%class, 'num', 1);
  $degree += $self->CheckClass(\%class, 'other', 1);

  if (defined($class{sp})) {
    if ($class{sp} >= 3) {$degree += 2; }
    elsif ($class{sp} >= 2) {$degree += 1; }
    delete $class{sp};
  }

  my @oth_chr = keys %class;
  if ($#oth_chr >= 1) {$degree += 1; }

  return $degree;
};

sub CheckClass {
  my ($self, $hash, $class, $thres) = @_;
  my $deg = 0;
  if (! defined($thres)) {$thres = 1; }
  if (defined($hash->{$class})) {
    if ($hash->{$class} > $thres) {$deg = 2; }
    else {$deg = 1; }
    delete ($hash->{$class});
  }
  return $deg;
}

1;

