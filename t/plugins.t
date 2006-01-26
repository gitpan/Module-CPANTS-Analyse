use Test::More tests => 5;
use Test::Deep;

use Module::CPANTS::Analyse;

my $a=Module::CPANTS::Analyse->new({});

{
	my @plugins=$a->plugins;
	is(@plugins,6,'number of plugins');
}


my $plugins=$a->mck->generators;

is(shift(@$plugins),'Module::CPANTS::Kwalitee::Files','plugin order 1 Files');
is(shift(@$plugins),'Module::CPANTS::Kwalitee::Distname','plugin order 2 Distname');
is(shift(@$plugins),'Module::CPANTS::Kwalitee::FindModules','plugin order 3 FindModules');

cmp_deeply($plugins,bag(qw(Module::CPANTS::Kwalitee::Pod Module::CPANTS::Kwalitee::Prereq Module::CPANTS::Kwalitee::Uses)),'plugin order the rest');


