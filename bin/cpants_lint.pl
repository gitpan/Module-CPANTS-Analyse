#!/usr/bin/perl -w
use strict;

use Module::CPANTS::Analyse;

my $dist=shift(@ARGV);
my $mca=Module::CPANTS::Analyse->new({dist=>$dist});
$mca->unpack;
$mca->analyse;
$mca->calc_kwalitee;

my @gen=$mca->mck->get_indicators;
my $max_kw=@gen;

print "The dist $dist gets ".$mca->d->{kwalitee}{kwalitee}." of $max_kw\n";


