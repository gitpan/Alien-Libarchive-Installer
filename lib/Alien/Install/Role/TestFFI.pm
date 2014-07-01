package Alien::Install::Role::TestFFI;

use strict;
use warnings;
use Role::Tiny;
use Alien::Install::Util;

# ABSTRACT: Test ffi alien role
our $VERSION = '0.08_04'; # VERSION

requires 'test_ffi_signature';
requires 'test_ffi_version';

sub test_ffi
{
  my($self) = @_;
  require FFI::Raw;
  delete $self->{error};
  
  my @sig = $self->test_ffi_signature;
  
  foreach my $dll ($self->dlls)
  {
    my $function = eval {
      FFI::Raw->new(
        $dll,
        @sig,
      );
    };
    next if $@;
    my $version = $self->test_ffi_version($function);
    return $self->{version} = $version if defined $version;
  }
  $self->{error} = "could not find $sig[0]";
  return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Install::Role::TestFFI - Test ffi alien role

=head1 VERSION

version 0.08_04

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
