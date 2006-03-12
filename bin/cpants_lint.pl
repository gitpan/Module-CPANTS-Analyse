#!/usr/bin/perl -w
use strict;

use Module::CPANTS::Analyse;

my $dist=shift(@ARGV);

die "usage: cpants_lint.pl path/to/Foo-Dist-1.42.tgz\n" unless $dist;
die "Cannot find $dist\n" unless -e $dist;

my $mca=Module::CPANTS::Analyse->new({dist=>$dist});
$mca->unpack;
$mca->analyse;
$mca->calc_kwalitee;

my @gen=$mca->mck->get_indicators;
my $max_kw=@gen;

my $kw=$mca->d->{kwalitee}{kwalitee};

print "\n";
print "Checked dist \t\t".$mca->tarball,"\n";
print "Kwalitee rating\t\t".$kw."/$max_kw\n";

if ($kw == $max_kw) {
    print "\nCongratulations for building a 'perfect' distribution!\n";
} else {
    my $kwl=$mca->d->{kwalitee};
    print "\nHere is a list of failed Kwalitee tests and\nwhat you can do to solve them:\n";
    foreach my $ind (@{$mca->mck->get_indicators}) {
        next if $kwl->{$ind->{name}};
        print "* ".$ind->{name}."\n";
        print $ind->{remedy}."\n\n";
    
    }
}

#use Data::Dumper;
#print join("\n",sort keys %{$mca->d});

__END__

=head1 NAME

cpants_lint.pl - commandline frontend to Module::CPANTS::Analyse

=head1 SYNOPSIS

  cpants_lint.pl path/to/Foo-Dist-1.42.tgz

=head1 DESCRIPTION

See C<Module::CPANTS::Analyse>

=head1 AUTHOR

Thomas Klausner, <domm@cpan.org>, http://domm.zsi.at

=head1 LICENSE

You may use and distribute this module according to the same terms
that Perl is distributed under.

=cut


