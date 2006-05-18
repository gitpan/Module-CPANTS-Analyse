package Module::CPANTS::Kwalitee;
use strict;
use warnings;
use base qw(Class::Accessor);
use Module::Pluggable search_path=>['Module::CPANTS::Kwalitee'];
use Carp;

__PACKAGE__->mk_accessors(qw(generators));

sub new {
    my $class=shift;
    my $me=bless {},$class;
    
    my %generators;
    foreach my $gen ($me->plugins) {
        eval "require $gen";
        croak qq{cannot load $gen: $@} if $@;
        $generators{$gen}=$gen->order;        
    }
    my @generators=sort { $generators{$a} <=> $generators{$b} } keys %generators;
    $me->generators(\@generators);

    return $me;
}


sub get_indicators {
    my $self=shift;
    
    my @indicators;
    foreach my $gen (@{$self->generators}) {
        foreach my $ind (@{$gen->kwalitee_indicators}) {
            $ind->{defined_in}=$gen;
            push(@indicators,$ind); 
        }
    }
    return wantarray ? @indicators : \@indicators;
}

sub get_indicators_hash {
    my $self=shift;

    my %indicators;
    foreach my $gen (@{$self->generators}) {
        foreach my $ind (@{$gen->kwalitee_indicators}) {
            $ind->{defined_in}=$gen;
            $indicators{$ind->{name}}=$ind;
        }
    }
    return \%indicators;
}

sub available_kwalitee {
    return scalar @{shift->get_indicators};
}


q{Favourite record of the moment:
  Jahcoozi: Pure Breed Mongrel};

__END__

=pod

=head1 NAME

Module::CPANTS::Kwalitee - Interface to Kwalitee generators

=head1 SYNOPSIS

  my $mck=Module::CPANTS::Kwalitee->new;
  my @generators=$mck->generators;
  
=head1 DESCRIPTION

=head2 Methods

=head3 new

Plain old constructor.

Loads all Plugins.

=head3 get_indicators

Get the list of all Kwalitee indicators, either as an ARRAY or ARRAYREF.

=head3 get_indicators_hash

Get the list of all Kwalitee indicators as an HASHREF.

=head1 SEE ALSO

L<Module::CPANTS::Analyse>

=head1 AUTHOR

Thomas Klausner, <domm@cpan.org>, http://domm.zsi.at

=head1 LICENSE

You may use and distribute this module according to the same terms
that Perl is distributed under.

=cut

