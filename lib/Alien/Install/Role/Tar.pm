package Alien::Install::Role::Tar;

use strict;
use warnings;
use Role::Tiny;
use Alien::Install::Util;

# ABSTRACT: Alien::Install role to extract from tar files
our $VERSION = '0.08_02'; # VERSION

sub extract
{
  my(undef, $archive, $dir) = @_;
  
  require Archive::Tar;
  my $tar = Archive::Tar->new;
  $tar->read($archive);
  
  require Cwd;
  my $save = Cwd::getcwd();
  chdir $dir;
  
  eval {
    $tar->extract;
  };
  
  my $error = $@;
  chdir $save;
  die $error if $error;
}

register_build_requires 'Archive::Tar' => 0;

sub chdir_source
{
  my(undef, $dir) = @_;
  chdir $dir;
  chdir do {
    opendir my $dh, '.';
    my @list = grep !/^\./, readdir $dh;
    closedir $dh;
    die "unable to find source in build root" if @list == 0;
    die "confused by multiple entries in the build root" if @list > 1;
    $list[0];
  };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Install::Role::Tar - Alien::Install role to extract from tar files

=head1 VERSION

version 0.08_02

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
