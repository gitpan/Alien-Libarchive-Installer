package Alien::Install::Role::HTTP;

use strict;
use warnings;
use Role::Tiny;
use Alien::Install::Util;

# ABSTRACT: Installer role for downloading via HTTP
our $VERSION = '0.08_05'; # VERSION

requires '_config_versions_url';
requires '_config_versions_process';

sub _version_sort
{
  shift; # $class
  sort { $a <=> $b } @_;
}

sub versions
{
  my($class) = @_;
  require HTTP::Tiny;
  my $url = $class->_config_versions_url;
  my $response = HTTP::Tiny->new->get($url);
  
  die sprintf("%s %s %s", $response->{status}, $response->{reason}, $url)
    unless $response->{success};

  my $process = $class->_config_versions_process;
  
  my $sort = eval { $class->_config_versions_sort } || \&_version_sort;
  
  if(ref($process) eq 'CODE')
  {
    return $sort->($class, $process->($response->{content}));
  }
  elsif(ref($process) eq 'Regexp')
  {
    my %versions;
    $versions{$1} = 1 while $response->{content} =~ /$process/g;
    return $sort->($class, keys %versions);
    
  }
}

requires '_config_fetch_url';

sub fetch
{
  my($class, %options) = @_;
  
  my $dir = $options{dir} || eval { require File::Temp; File::Temp::tempdir( CLEANUP => 1 ) };

  my $version = $options{version} || do {
    my @versions = $class->versions;
    die "unable to determine latest version from listing"
      unless @versions > 0;
    $versions[-1];
  };
  
  my $env = uc $class;
  $env =~ s/::/_/g;

  if(defined $ENV{"$env\_MIRROR"})
  {
    my $fn = catfile($ENV{"$env\_MIRROR"}, "libarchive-$version.tar.gz");
    return wantarray ? ($fn, $version) : $fn;
  }

  my $url = $class->_config_fetch_url->($class, $version);
  
  require HTTP::Tiny;  
  my $response = HTTP::Tiny->new->get($url);
  
  die sprintf("%s %s %s", $response->{status}, $response->{reason}, $url)
    unless $response->{success};
  
  my $fn = $url;
  $fn =~ s{^.*/}{};
  $fn = "tarball.tar.gz" unless $fn;    
  $fn = catfile($dir, $fn);
  
  open my $fh, '>', $fn;
  binmode $fh;
  print $fh $response->{content};
  close $fh;
  
  wantarray ? ($fn, $version) : $fn;
}

register_build_requires 'HTTP::Tiny' => 0;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Alien::Install::Role::HTTP - Installer role for downloading via HTTP

=head1 VERSION

version 0.08_05

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
