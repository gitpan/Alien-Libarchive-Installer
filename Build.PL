
# This file was automatically generated by Dist::Zilla::Plugin::ModuleBuild v5.023.
use strict;
use warnings;

use Module::Build 0.28;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.28"
  },
  "configure_requires" => {
    "Module::Build" => "0.28",
    "perl" => "5.006"
  },
  "dist_abstract" => "Installer for libarchive",
  "dist_author" => [
    "Graham Ollis <plicease\@cpan.org>"
  ],
  "dist_name" => "Alien-Libarchive-Installer",
  "dist_version" => "0.10",
  "license" => "perl",
  "module_name" => "Alien::Libarchive::Installer",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "ExtUtils::CBuilder" => 0,
    "perl" => "5.006"
  },
  "script_files" => [],
  "test_requires" => {
    "Test::More" => "0.94",
    "perl" => "5.006"
  }
);


my %fallback_build_requires = (
  "Module::Build" => "0.28",
  "Test::More" => "0.94",
  "perl" => "5.006"
);


unless ( eval { Module::Build->VERSION(0.4004) } ) {
  delete $module_build_args{test_requires};
  $module_build_args{build_requires} = \%fallback_build_requires;
}

my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
