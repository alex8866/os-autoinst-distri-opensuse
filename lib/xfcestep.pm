package xfcestep;
use base "x11step";
use bmwqemu;

sub is_applicable() {
    my $self = shift;
    return $self->SUPER::is_applicable && ( $vars{DESKTOP} eq "xfce" );
}

1;
# vim: set sw=4 et: