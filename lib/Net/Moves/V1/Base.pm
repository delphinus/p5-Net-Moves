package Net::Moves::V1::Base;
use strict;
use warnings;
use Carp;
use Data::Util qw!:check!;
use JSON;
use parent qw!Class::Accessor::Fast!;

sub _get { my $self = shift; #{{{
    my $uri_part = shift || '';
    my $res = $self->access_token->get($self->_end_point . $uri_part);

    return $res->is_error ? $res->as_string : decode_json $res->content;
} #}}}

1;
