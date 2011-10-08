#!perl
use strict;
use warnings;

use Test::More 0.88;

use Test::DZil;
use Path::Class;

my $tzil = Builder->from_config(
  { dist_root => 'corpus/' },
  { },
);

$tzil->build;

my $dir = dir($tzil->tempdir, 'build');

ok -e $dir->file('ppport.h');
ok -s $dir->file('ppport.h');

done_testing;
