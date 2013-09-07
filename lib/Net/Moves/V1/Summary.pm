package Net::Moves::V1::Summary;
use strict;
use warnings;
use Carp;
use Data::Util qw!:check!;
use parent qw!Net::Moves::V1::Base!;

__PACKAGE__->mk_accessors(qw!
    access_token
    _end_point
!);

sub new { my $class = shift; #{{{
    my $self = $class->SUPER::new(is_hash_ref($_[0]) ? $_[0] : +{@_});

    return $self->_init;
} #}}}

sub _init { my $self = shift; #{{{
    croak "'access_token' is needed."
        unless is_instance $self->access_token => 'Net::OAuth2::AccessToken';

    $self->_end_point('/api/v1/user/summary/daily');

    return $self;
} #}}}

sub day { my $self = shift; #{{{
    my $date = shift;

    croak 'specify date in yyyyMMdd or yyyy-MM-dd format'
        unless is_string $date && $date =~ /^\d{4}-?\d\d-?\d\d$/;

    return $self->_get("/$date");
} #}}}

sub week { my $self = shift; #{{{
    my $week = shift;

    croak 'specify week in yyyy-’W’ww format, for example 2013-W09'
        unless is_string $week && $week =~ /^\d{4}-W\d\d$/;

    return $self->_get("/$week");
} #}}}

sub month { my $self = shift; #{{{
    my $month = shift;

    croak 'specify date in yyyyMM or yyyy-MM format'
        unless is_string $month && $month =~ /^\d{4}-?\d\d$/;

    return $self->_get("/$month");
} #}}}

sub range { my $self = shift; #{{{
    my ($from, $to) = @_;

    croak 'specify range start and end in yyyyMMdd or yyyy-MM-dd format'
        unless is_string $from && $from =~ /^\d{4}-?\d\d-?\d\d$/
            && is_string $from && $from =~ /^\d{4}-?\d\d-?\d\d$/;

    return $self->_get("?from=$from&to=$to");
} #}}}

sub past_days { my $self = shift; #{{{
    my $days = shift;

    croak 'specify days in integer' unless is_integer $days;

    return $self->_get("?pastDays=$days");
} #}}}

1;
