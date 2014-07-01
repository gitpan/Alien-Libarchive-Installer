package Alien::Install::Role::TestCompileRun;

use strict;
use warnings;
use Role::Tiny;
use Alien::Install::Util;

# ABSTRACT: Test compile alien role
our $VERSION = '0.08_04'; # VERSION

requires 'error';
requires '_config_test_compile_run_program';

register_build_requires  'ExtUtils::CBuilder' => 0;
register_system_requires 'ExtUtils::CBuilder' => 0;

sub test_compile_run
{
  my($self, %opt) = @_;
  delete $self->{error};
  $self->{quiet} = 1 unless defined $self->{quiet};
  my $cbuilder = $opt{cbuilder} || do { require ExtUtils::CBuilder; ExtUtils::CBuilder->new(quiet => $self->{quiet}) };
  
  unless($cbuilder->have_compiler)
  {
    $self->{error} = 'no compiler';
    return;
  }
  
  my $dir = $opt{dir} || do { require File::Temp; File::Temp::tempdir( CLEANUP => 1 ) };
  my $fn = catfile($dir, 'test.c');
  spew $fn, $self->_config_test_compile_run_program;
  
  
  my $exe = eval {

    my $obj = $cbuilder->compile(
      source               => $fn,
      extra_compiler_flags => $self->cflags || [],
    );

    $cbuilder->link_executable(
      objects            => $obj,
      extra_linker_flags => $self->libs || [],
    );
    
  };

  if(my $error = $@)
  {
    $self->{error} = $error;
    return;
  }
  
  if($exe =~ /\s/)
  {
    $exe = Win32::GetShortPathName($exe) if $^O eq 'MSWin32';
    $exe = Cygwin::win_to_posix_path(Win32::GetShortPathName(Cygwin::posix_to_win_path($exe))) if $^O eq 'cygwin';
  }
  
  my $output = `$exe`;
  
  if($? == -1)
  {
    $self->{error} = "failed to execute $!";
    return;
  }
  elsif($? & 127)
  {
    $self->{error} = "child died with signal " . ($? & 127);
    return;
  }
  elsif($?)
  {
    $self->{error} = "child exited with value " . ($? >> 8);
  }
  
  my $match = $self->can('_config_test_compile_run_match') ? $self->_config_test_compile_run_match : qr{version = '(.*?)'};
  
  if($output =~ $match)
  {
    return $self->{version} = $1;
  }
  else
  {
    $self->{error} = "unble to retrieve version from output";
    return;
  }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Install::Role::TestCompileRun - Test compile alien role

=head1 VERSION

version 0.08_04

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
