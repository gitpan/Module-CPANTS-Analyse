package Module::CPANTS::Kwalitee::MetaYML;
use warnings;
use strict;
use File::Spec::Functions qw(catfile);
use YAML qw(LoadFile);

sub order { 20 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class=shift;
    my $me=shift;

    my $files=$me->d->{files_array};
    my $distdir=$me->distdir;
    if (grep {/^META\.yml$/} @$files) {
        eval {
            $me->d->{meta_yml}=LoadFile(catfile($distdir,'META.yml'));
            $me->d->{metayml_is_parsable}=1;
        };
        if ($@) {
            $me->d->{metayml_parse_error}=$@;
        }
    }    
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators{
    return [
        {
            name=>'metayml_is_parsable',
            error=>q{The META.yml file of this distributioncould not be parsed by the version of YAML.pm CPANTS is using.},
            remedy=>q{Upgrade your YAML.pm or convince the maintainer of CPANTS that he has to upgrade.},
            code=>sub { shift->{metayml_is_parsable} ? 1 : 0 }
        },
        {
            name=>'metayml_has_license',
            error=>q{This distribution does not have a license defined in META.yml.},
            remedy=>q{Define the license if you are using in Build.PL. If you are using MakeMaker (Makefile.PL) you should upgrade to ExtUtils::MakeMaker version 6.31.},
            code=>sub { 
                my $d=shift;
                my $yaml=$d->{meta_yml};
                ($yaml->{license} and $yaml->{license} ne 'unknown') ? 1 : 0 }
        },
        {
            name=>'metayml_has_required_fields',
            error=>q{Some required fields are missing in META.yml},
            remedy=>q{Add the required fields to META.yml. Required fields are listed in the META.yml Spec at http://module-build.sourceforge.net/META-spec-current.html},
            code=>sub {
                my $d=shift;
                my $yaml=$d->{meta_yml};
                my $ok;
                my @fields=qw(meta-spec name version abstract author license generated_by);
                foreach my $field (@fields) {
                    $ok++ if defined $yaml->{$field};
                }
                $ok == @fields ? 1 : 0;  
            },
        },

    ];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};

__END__

=pod

=head1 NAME

Module::CPANTS::Kwalitee::MetaYML - Checks data availabe in META.yml

=head1 SYNOPSIS

Checks various pieces of information in META.yml

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<11>.

=head3 analyse

C<MCK::MetaYML> checks C<META.yml>.

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * metayml_is_parsable

=item * metayml_has_required_fields

=item * metayml_has_license

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

Thomas Klausner, <domm@cpan.org>, http://domm.zsi.at
and Gabor Szabo, <gabor@pti.co.il>, http://www.szabgab.com

=head1 COPYRIGHT

You may use and distribute this module according to the same terms
that Perl is distributed under.

=cut
