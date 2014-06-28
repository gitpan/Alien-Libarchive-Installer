package Alien::Install;

use strict;
use warnings;

# ABSTRACT: Install your aliens
our $VERSION = '0.08_02'; # VERSION


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Install - Install your aliens

=head1 VERSION

version 0.08_02

=head1 DESCRIPTION

I'm working on abstracting out all the generic bits out of
L<Alien::Libarchive::Installer> to eventually make a
L<Alien::Install> distribution.  For a few development
releases, L<Alien::Install> and other modules under it will
be bundled with L<Alien::Libarchive::Installer>.  The next
production release of L<Alien::Libarchive::Installer> will
not have this code bundled with it.

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
