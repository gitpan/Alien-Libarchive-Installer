package Alien::Install::Role::VersionSortSimple;

use strict;
use warnings;
use Role::Tiny;

# ABSTRACT: Sort versions that are a simple floating point value
our $VERSION = '0.08_06'; # VERSION

around versions => sub {
  my $orig  = shift;
  my $class = shift;
  my %list = map { $_ => 1 } $orig->($class, @_);
  sort { $a <=> $b } keys %list;
};

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Install::Role::VersionSortSimple - Sort versions that are a simple floating point value

=head1 VERSION

version 0.08_06

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
