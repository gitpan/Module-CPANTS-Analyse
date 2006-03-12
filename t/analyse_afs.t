use Test::More tests => 7;

use Module::CPANTS::Analyse;
use File::Spec::Functions;
my $a=Module::CPANTS::Analyse->new({
    dist=>'t/eg/AFS-2.4.0.tar.gz',
    _dont_cleanup=>$ENV{DONT_CLEANUP},
});

my $rv=$a->unpack;
is($rv,undef,'unpack ok');

$a->analyse;

my $d=$a->d;

is($d->{files},384,'files');
is($d->{size_packed},184395,'size_packed');
is(ref($d->{modules}),'ARRAY','modules is ARRAY');
is($d->{modules}[0]->{module},'AFS','module');
is(ref($d->{prereq}),'ARRAY','prereq is ARRAY');
is(ref($d->{uses}),'HASH','uses is HASH');


