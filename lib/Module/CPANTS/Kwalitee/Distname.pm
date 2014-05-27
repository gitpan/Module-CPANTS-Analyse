package Module::CPANTS::Kwalitee::Distname;
use warnings;
use strict;

our $VERSION = '0.93_01';
$VERSION = eval $VERSION; ## no critic

sub order { 20 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class=shift;
    my $me=shift;

    # NOTE: The analysis code has moved to ::Analyse to avoid
    # duplication.

    # Note also that this stub should not be removed so that
    # this can replace the old ::Distname module, and the old
    # metrics will not be loaded while loading plugins.
    return;
}


##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
    # NOTE: The metrics in this module have moved to
    # Module::CPANTS::SiteKwalitee because these require an archived
    # distribution which you don't have while testing local Kwalitee
    # with Test::Kwalitee.

    return [];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};


__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::Kwalitee::Distname - Proper Distname layout

=head1 SYNOPSIS

Checks if a distname is well-formed.

A well-formed distname looks like C<Foo-Bar-1.42.tgz>

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<20>, as data generated by C<MCK::Distname> is used by other tests.

=head3 analyse

C<MCK::Distname> uses C<CPAN::DistnameInfo> to split a distname into it's components.

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2006, 2009 L<Thomas Klausner|https://metacpan.org/author/domm>

You may use and distribute this module according to the same terms
that Perl is distributed under.
