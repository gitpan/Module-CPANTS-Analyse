use Test::More tests => 10;
use Test::Deep;

use Module::CPANTS::Kwalitee;

my $k=Module::CPANTS::Kwalitee->new({});

is($k->available_kwalitee,21,'available kwalitee');
is($k->total_kwalitee,23,'total kwalitee');


my $ind=$k->get_indicators_hash;
is(ref($ind),'HASH','indicator_hash');
is(ref($ind->{use_strict}),'HASH','hash element');

{
    my @all=$k->all_indicator_names;
    is(@all,23,'number of indicators');
    my $all=$k->all_indicator_names;
    is(@$all,23,'number of indicators');
}

{
    my @all=$k->core_indicator_names;
    is(@all,21,'number of indicators');
    my $all=$k->core_indicator_names;
    is(@$all,21,'number of indicators');
}

{
    my @all=$k->optional_indicator_names;
    is(@all,2,'number of indicators');
    my $all=$k->optional_indicator_names;
    is(@$all,2,'number of indicators');
}
