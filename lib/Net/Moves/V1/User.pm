package Net::Moves::V1::User;
use strict;
use warnings;
use Carp;
use Data::Util qw!:check!;
use parent qw!Net::Moves::V1::Base!;

__PACKAGE__->mk_accessors(qw!
    access_token
    _user_profile
    _end_point
!);

sub new { my $class = shift; #{{{
    my $self = $class->SUPER::new(is_hash_ref($_[0]) ? $_[0] : +{@_});

    return $self->_init;
} #}}}

sub _init { my $self = shift; #{{{
    croak "'access_token' is needed."
        unless is_instance $self->access_token => 'Net::OAuth2::AccessToken';

    $self->_end_point('/api/v1/user/profile');

    return $self;
} #}}}

sub profile { my $self = shift; #{{{
    $self->_get_user_profile unless $self->_user_profile;

    return $self->_user_profile->{profile};
} #}}}

sub id { my $self = shift; #{{{
    $self->_get_user_profile unless $self->_user_profile;

    return $self->_user_profile->{userId};
} #}}}

sub _get_user_profile { my $self = shift; #{{{
    $self->_user_profile($self->_get);
} #}}}

1;
