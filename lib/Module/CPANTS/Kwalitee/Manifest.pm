package Module::CPANTS::Kwalitee::Manifest;
use warnings;
use strict;
use File::Spec::Functions qw(catfile);

sub order { 100 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my $class=shift;
    my $me=shift;
    
    my $files=$me->d->{files_array};
    my $distdir=$me->distdir;
    
    my $manifest_file=catfile($distdir,'MANIFEST');
    my $manifest_matches_dist=0;

    if (-e $manifest_file) {
        
        # read manifest
        open(my $fh,$manifest_file) || die "cannot read MANIFEST $manifest_file: $!";
        my @manifest;
        while (<$fh>) {
            chomp;
            s/\s.*$//;
            next unless /\w/;
            push(@manifest,$_);
        }
        close $fh;
        
        if (@manifest == @$files) {
            @manifest=sort @manifest;
            my @files=sort @$files;

            $manifest_matches_dist=1;
            for my $i (0..$#manifest) {
                if ($manifest[$i] ne $files[$i]) {
                    $manifest_matches_dist=0;
                    last;
                }
            }
        }
    }

    $me->d->{manifest_matches_dist}=$manifest_matches_dist;
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
    return [
        {
            name=>'manifest_matches_dist',
            error=>q{MANIFEST does not match the contents of this distribution.},
            remedy=>q{Use a buildtool to generate the MANIFEST. Or update MANIFEST manually.},
            code=>sub { shift->{manifest_matches_dist} ? 1 : 0 },
        }
    ];
}


q{Listening to: YAPC::Europe 2007};

__END__

=pod

=head1 NAME

Module::CPANTS::Kwalitee::Manifest - Check MANIFEST

=head1 SYNOPSIS

Check if MANIFEST and dist contents match.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<100>.

=head3 analyse

Check if MANIFEST and dist contents match.

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over

=item * manifest_matches_dist

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

Thomas Klausner, <domm@cpan.org>, http://domm.plix.at

=head1 COPYRIGHT

You may use and distribute this module according to the same terms
that Perl is distributed under.

=cut
