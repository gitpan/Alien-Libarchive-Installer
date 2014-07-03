package Alien::Install::Role::VersionSortMultiple;

use strict;
use warnings;
use Role::Tiny;

# ABSTRACT: Sort versions that are a multiple integers separated by dot
our $VERSION = '0.08_06'; # VERSION

my $cmp = sub {
  my @a = @{$_[0]};
  my @b = @{$_[1]};
  
  while(@a > 0 || @b > 0)
  {
    my($a,$b) = (shift(@a)||0, shift(@b)||0);
    return $a <=> $b if $a <=> $b;
  }
  
  0
};

around versions => sub {
  my $orig  = shift;
  my $class = shift;
  my %list = map { $_ => 1 } @_;
  map { join '.', @$_ }
  sort { $cmp->($a, $b) }
  map { [split /\./] }
  $orig->($class, keys %list);
};

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Install::Role::VersionSortMultiple - Sort versions that are a multiple integers separated by dot

=head1 VERSION

version 0.08_06

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
