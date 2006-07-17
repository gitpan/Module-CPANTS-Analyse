use Test::More tests => 2;
use Test::Deep;

use Module::CPANTS::Kwalitee;

my $k=Module::CPANTS::Kwalitee->new({});

is($k->available_kwalitee,17,'available kwalitee');
is($k->total_kwalitee,18,'total kwalitee');


