package Alien::Install::Role::Installer;

use strict;
use warnings;
use Role::Tiny;
use Alien::Install::Util;

# ABSTRACT: Role for Alien::Install
our $VERSION = '0.08_02'; # VERSION

requires 'versions';
requires 'fetch';
requires 'extract';
requires 'chdir_source';
requires 'test_compile_run';
requires 'test_ffi';

my $build_requires = \%Alien::Install::Util::build_requires;

sub build_requires
{
  my($class) = @_;
  my %requires;
  foreach my $role (keys %$build_requires)
  {
    if($class->isa($role) || $class->does($role))
    {
      while(my($mod,$ver) = each %{ $build_requires->{$role} })
      {
        # TODO check if this is a newer or older
        # than existing $ver
        $requires{$mod} = $ver;
      }
    }
  }
  
  \%requires;
}

my $system_requires = \%Alien::Install::Util::system_requires;

sub system_requires
{
  my($class) = @_;
  my %requires;
  foreach my $role (keys %$system_requires)
  {
    if($class->isa($role) || $class->does($role))
    {
      while(my($mod,$ver) = each %{ $system_requires->{$role} })
      {
        # TODO check if this is a newer or older
        # than existing $ver
        $requires{$mod} = $ver;
      }
    }
  }
  
  \%requires;
}

my $hooks = \%Alien::Install::Util::hooks;

sub call_hooks
{
  my($class, $name, @args) = @_;
  # TODO probably could cache the hooks that we need for each class..
  foreach my $role (keys %$hooks)
  {
    if($class->isa($role) || $class->does($role))
    {
      if(exists $hooks->{$role}->{$name})
      {
        $_->($class, @args) for @{ $hooks->{$role}->{$name} };
      }
    }
  }
}

register_hook 'post_install' => sub {
  my($class, $prefix) = @_;

  foreach my $name ($^O =~ /^(MSWin32|cygwin)$/ ? ('bin','lib') : ('lib'))
  {
    do {
      my $static_dir = catdir($prefix, $name);
      my $dll_dir    = catdir($prefix, 'dll');
      require File::Path;
      File::Path::mkpath($dll_dir, 0, 0755);
      my $dh;
      opendir $dh, $static_dir;
      my @list = readdir $dh;
      @list = grep { /\.so/ || /\.(dylib|la|dll|dll\.a)$/ } grep !/^\./, @list;
      closedir $dh;
      foreach my $basename (@list)
      {
        my $from = catfile($static_dir, $basename);
        my $to   = catfile($dll_dir,    $basename);
        if(-l $from)
        {
          symlink(readlink $from, $to);
          unlink($from);
        }
        else
        {
          require File::Copy;
          File::Copy::move($from, $to);
        }
      }
    };
  }
};

sub error   { shift->{error}   }
sub cflags  { shift->{cflags}  }
sub libs    { shift->{libs}    }
sub version { shift->{version} }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Install::Role::Installer - Role for Alien::Install

=head1 VERSION

version 0.08_02

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
