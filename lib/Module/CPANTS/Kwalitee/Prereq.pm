package Module::CPANTS::Kwalitee::Prereq;
use warnings;
use strict;
use File::Spec::Functions qw(catfile);
use YAML qw(LoadFile);

sub order { 100 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class=shift;
    my $me=shift;
    
    my $files=$me->d->{files_array};
    my $distdir=$me->distdir;

    my $prereq;
    if (grep {/^META\.yml$/} @$files) {
        my $yaml;
        eval {
            $yaml=LoadFile(catfile($distdir,'META.yml'));
        };

        if ($yaml) {
            if ($yaml->{requires}) {
                $prereq=$yaml->{requires};
            }
        }
    } elsif (grep {/^Build\.PL$/} @$files) {
        open(IN,catfile($distdir,'Build.PL')) || return 1;
        my $m=join '', <IN>;
        close IN;
        my($requires) = $m =~ /requires.*?=>.*?\{(.*?)\}/s;
        eval "{ no strict; \$prereq = { $requires \n} }";
        
    } else {
        open(IN,catfile($distdir,'Makefile.PL')) || return 1;
        my $m=join '', <IN>;
        close IN;

        my($requires) = $m =~ /PREREQ_PM.*?=>.*?\{(.*?)\}/s;
        $requires||='';
        eval "{ no strict; \$prereq = { $requires \n} }";
    }
    return unless $prereq;
    
    if (!ref $prereq) {
        my $p={$prereq=>0};
        $prereq=$p;
    }

    # sanitize version
    my @clean;
    while (my($requires,$version)=each%$prereq) {
        $version||=0;
        $version=0 unless $version=~/[\d\._]+/;
        push(@clean,{
            requires=>$requires,
            version=>$version,
        });
    }
    $me->d->{prereq}=\@clean;
    return;
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators{
    return [
#        {
#            name=>'is_prereq',
#            error=>q{This distribution is not required by another distribution by another author.},
#            remedy=>q{Convince / force / bribe another CPAN author to use this distribution.},
#            code=>sub {
#                return 0;               
                #my $d=shift;
                #my $pauseid=$d->author->pauseid;
                #my $it=Module::CPANTS::DB::Dist->search_required_by_otherauthor(
                    #    $dist->id,$pauseid
                    #);
                    #my $required=$it->count;
                    #return 1 if $required;
#            },
#        },
    ];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};

__END__

=pod

=head1 NAME

Module::CPANTS::Kwalitee::Prereq - Checks listed prerequistes

=head1 SYNOPSIS

Checks which other dists a dist declares as requirements.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<100>.

=head3 analyse

C<MCK::Prereq> checks C<META.yml>, C<Build.PL> or C<Makefile.PL> for prereq-listings. 

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * is_prereq (currently deactived)

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

Thomas Klausner, <domm@cpan.org>, http://domm.zsi.at

=head1 COPYRIGHT

You may use and distribute this module according to the same terms
that Perl is distributed under.

=cut
