use Test::More tests => 10;

use Module::CPANTS::Analyse;
use File::Spec::Functions;
my $a=Module::CPANTS::Analyse->new({
    dist=>'t/eg/Acme-DonMartin-0.06.tar.gz',
    _dont_cleanup=>$ENV{DONT_CLEANUP},
});

my $rv=$a->unpack;
is($rv,undef,'unpack ok');

$a->analyse;

my $d=$a->d;

is($d->{files},9,'files');
is($d->{size_packed},7736,'size_packed');
is(ref($d->{modules}),'ARRAY','modules is ARRAY');
is($d->{modules}[0]->{module},'Acme::DonMartin','module');
is(ref($d->{prereq}),'ARRAY','prereq is ARRAY');
is($d->{prereq}[0]->{requires},'Compress::Zlib','prereq');
is(ref($d->{uses}),'HASH','uses is HASH');
is($d->{uses}{'Compress::Zlib'}{module},'Compress::Zlib','uses');
is($d->{uses}{'Test::More'}{in_tests},1,'uses');

#use Data::Dumper;
#diag(Dumper $d);

