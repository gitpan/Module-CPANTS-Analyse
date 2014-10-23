package #
  xt::kwalitee::Test;

use strict;
use warnings;
use FindBin;
use Test::More;

BEGIN {
  eval { require WorePAN };
  plan skip_all => "requires WorePAN" if $@ or $WorePAN::VERSION < 0.09;
}

use Module::CPANTS::Analyse;

sub run {
  my (@tests) = @_;

  my ($caller, $file) = caller;

  my ($name) = $file =~ /(\w+)\.t$/;

  plan tests => scalar @tests;

  for my $test (@tests) {
    my $worepan = WorePAN->new(
      root => "$FindBin::Bin/tmp",
      files => [$test->[0]],
      no_indices => 1,
      use_backpan => 1,
      no_network => 0,
      cleanup => 1,
    );
    my $tarball = $worepan->file($test->[0]);
    my $analyzer = Module::CPANTS::Analyse->new({dist => $tarball});
    $analyzer->unpack;
    $analyzer->analyse;
    my $metric = $analyzer->mck->get_indicators_hash->{$name};
    my $result = $metric->{code}->($analyzer->d);
    is $result => $test->[1], "$test->[0] $name: $result";
  }
}

1;
