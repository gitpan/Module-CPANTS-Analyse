package Module::CPANTS::Kwalitee::Pod;
use warnings;
use strict;
use File::Spec::Functions qw/catfile/;
use Encode;

our $VERSION = '0.93_03';
$VERSION = eval $VERSION; ## no critic

our @ABSTRACT_STUBS = (
  q{Perl extension for blah blah blah}, # h2xs
  q{[One line description of module's purpose here]}, # Module::Starter etc
  q{It's new $module}, # Minilla
);

sub order { 100 }

##################################################################
# Analyse
##################################################################

sub analyse {
    my ($class, $me) = @_;
    my $distdir = $me->distdir;
    my %abstract;
    my @errors;
    for my $module (@{$me->d->{modules} || []}) {
        my ($package, $abstract, $error) = $class->_parse_abstract(catfile($distdir, $module->{file}));
        push @errors, "$error ($package)" if $error;
        $me->d->{abstracts_in_pod}{$package} = $abstract if $package;
    }

    # sometimes pod for .pm file is put into .pod
    for my $file (@{$me->d->{files_array} || []}) {
        next unless $file =~ /\.pod$/ && ($file =~ m!^lib/! or $file =~ m!^[^/]+$!);
        local $@;
        my ($package, $abstract, $error) = $class->_parse_abstract(catfile($distdir, $file));
        push @errors, "$error ($package)" if $error;
        $me->d->{abstracts_in_pod}{$package} = $abstract if $package;
    }
    $me->d->{error}{has_abstract_in_pod} = join ';', @errors if @errors;
}

# adapted from ExtUtils::MM_Unix and Module::Build::PodParser
sub _parse_abstract {
    my ($class, $file) = @_;
    my ($package, $abstract);
    my $inpod = 0;
    open my $fh, '<', $file or return;
    my $directive;
    my $encoding;
    while(<$fh>) {
        if (/^=encoding\s+(.+)/) {
            $encoding = $1;
        }
        if (/^=(?!cut)(.+)/) {
            $directive = $1;
            $inpod = 1;
        } elsif (/^=cut/) {
            $inpod = 0;
        }
        next if !$inpod;
        next unless $directive =~ /^head/;
        if ( /^\s*((?:[A-Za-z0-9_]+::)*[A-Za-z0-9_]+ | [BCIF] < (?:[A-Za-z0-9_]+::)*[A-Za-z0-9_]+ >) \s+ -+ (?:\s+ (.*)\s*$|$)/x ) {
            ($package, $abstract) = ($1, $2);
            $package =~ s![BCIF]<([^>]+)>!$1!;
            next;
        }
        next unless $abstract;
        last if /^\s*$/ || /^=/;
        s/\s+$//s;
        $abstract .= "\n$_";
    }

    my $error;
    if ($encoding) {
        my $encoder = find_encoding($encoding);
        if (!$encoder) {
            $error = "unknown encoding: $encoding";
        } else {
            $abstract = eval { $encoder->decode($abstract) };
            if ($@) {
                $error = $@;
                $error =~ s|\s*at .+ line \d+.+$||s;
            }
        }
    }
    return ($package, $abstract, $error);
}

##################################################################
# Kwalitee Indicators
##################################################################

sub kwalitee_indicators {
    return [
      {
          name => 'has_abstract_in_pod',
          error => q{No abstract (short description of a module) is found in pod from this distribution.},
          remedy => q{Provide a short description in the NAME section of the pod (after the module name followed by a hyphen) at least for the main module of this distribution.},
          code => sub {
              my $d = shift;
              return 0 if $d->{error}{has_abstract_in_pod};
              my @abstracts = grep {defined $_ && length $_} values %{$d->{abstracts_in_pod} || {}};
              return @abstracts ? 1 : 0;
          },
          details => sub {
              my $d = shift;
              return "No abstracts in pod";
          },
      },
      {
          name => 'no_abstract_stub_in_pod',
          is_extra => 1,
          error => q{A well-known abstract stub (typically generated by an authoring tool) is found in this distribution.},
          remedy => q{Modify the stub. You might need to modify other stubs (for name, synopsis, license, etc) as well.},
          code => sub {
              my $d = shift;
              my %mapping = map {$_ => 1} @ABSTRACT_STUBS;
              my @errors;
              for (sort keys %{$d->{abstracts_in_pod} || {}}) {
                  push @errors, $_ if $mapping{$d->{abstracts_in_pod}{$_} || ''};
              }
              if (@errors) {
                  $d->{error}{no_abstract_stub_in_pod} = join ',', @errors;
              }
              return @errors ? 0 : 1;
          },
          details => sub {
              my $d = shift;
              my %mapping = map {$_ => 1} @ABSTRACT_STUBS;
              return "Abstracts in the following packages are stubs:". $d->{error}{no_abstract_stub_in_pod};
          },
      },
    ];
}


q{Favourite record of the moment:
  Fat Freddys Drop: Based on a true story};

__END__

=encoding UTF-8

=head1 NAME

Module::CPANTS::Kwalitee::Pod - Check Pod

=head1 SYNOPSIS

The check in this module has moved to L<Module::CPANTS::SiteKwalitee::Pod> to double-check the pod correctness on the server side.

If you do care, it is recommended to add a test to test pod (with L<Test::Pod>) in "xt/" directory in your distribution.

=head1 DESCRIPTION

=head2 Methods

=head3 order

Defines the order in which Kwalitee tests should be run.

Returns C<100>.

=head3 analyse

Does nothing now.

=head3 kwalitee_indicators

Returns the Kwalitee Indicators datastructure.

=over 4

=item * has_abstract_in_pod

=item * no_abstract_stub_in_pod

=back

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

L<Thomas Klausner|https://metacpan.org/author/domm>

=head1 COPYRIGHT AND LICENSE

Copyright © 2003–2006, 2009 L<Thomas Klausner|https://metacpan.org/author/domm>

You may use and distribute this module according to the same terms
that Perl is distributed under.
