package Net::Moves::V1;
use strict;
use warnings;
use Carp;
use Data::Util qw!:check!;
use Net::OAuth2::Client;

use Net::Moves::V1::User;
use Net::Moves::V1::Summary;

use parent qw!Class::Accessor::Fast!;

__PACKAGE__->mk_accessors(qw!
    access_token_data
    client
    client_id
    client_secret
    scope
    state
!);

sub new { my $class = shift; #{{{
    my $self = $class->SUPER::new(is_hash_ref($_[0]) ? $_[0] : +{@_});

    return $self->_init;
} #}}}

sub _init { my $self = shift; #{{{
    for my $arg (qw!client_id client_secret!) {
        croak "'$arg' must be a string." unless is_string $self->$arg;
    }

    $self->client(Net::OAuth2::Profile::WebServer->new(
        client_id => $self->client_id,
        client_secret => $self->client_secret,
        site => 'https://api.moves-app.com/api/v1',
        access_token_path => 'https://api.moves-app.com/oauth/v1/access_token',
    )) unless defined $self->client
        && is_instance $self->client => 'Net::OAuth2::Profile::WebServer';

    return $self;
} #}}}

sub authorize { my $self = shift; #{{{
    my %args = is_hash_ref($_[0]) ? %{$_[0]} : @_;

    if (is_string $args{scope}) {
        croak "'scope' must be 'activity' or 'location' or 'activity location'."
            unless $args{scope} eq 'activity'
                || $args{scope} eq 'location'
                || $args{scope} eq 'activity locaiton'
                || $args{scope} eq 'location activity';
    } else {
        $self->scope('activity');
    }

    $self->client->{NOP_authorize_url} = $args{mobile}
        ? 'moves://app/authorize'
        : 'https://api.moves-app.com/oauth/v1/authorize';

    return $self->client->authorize(%args, scope => $self->scope);
} #}}}

sub access_token { my $self = shift; #{{{
    my %args = is_hash_ref($_[0]) ? %{$_[0]} : @_;

    return $self->client->get_access_token($args{code},
        redirect_uri => $args{redirect_uri})
            if is_string($args{code}) && (
                is_string($args{redirect_uri})
                    || is_instance($args{redirect_uri} => 'URI'));

    my $access_token_data = $self->access_token_data
        || $args{access_token_data};

    return Net::OAuth2::AccessToken->session_thaw($access_token_data,
        profile => $self->client) if is_hash_ref $access_token_data;

    croak "either 'access_token_data' || ('code' && 'redirect_uri') is needed.";
} #}}}

sub user { my $self = shift; #{{{
    my $access_token = $self->access_token(access_token_data => shift);

    return Net::Moves::V1::User->new(access_token => $access_token);
} #}}}

sub summary { my $self = shift; #{{{
    my $access_token = $self->access_token(access_token_data => shift);

    return Net::Moves::V1::Summary->new(access_token => $access_token);
} #}}}

1; # End of Net::Moves::V1

=encoding utf-8

=head1 NAME

Net::Move::V1 - Moves API v1

=head1 SYNOPSIS

    my %args = (
        client_id => 'abcde12345',
        client_secret => '12345abcde'
        redirect_uri => 'http://localhost:5000/auth/moves/callback',
        mobile => 1,
    );

    get '/' => sub { my $c = shift;
        my $moves = Net::Moves::V1->new(%args);

        return $c->render('index.tt', +{
            authorize_uri => $moves->authorize,
        });
    };

    get '/auth/moves/callback' => sub { my $c = shift;
        my $moves = Net::Moves::V1->new(%args, code => $c->req->param('code'));
        # save access_token to a session variable.
        $c->session->set(access_token => $moves->access_token->session_freeze);

        return $c->redirect('/');
    };

    get '/moves/profile' => sub { my $c = shift;
        # get access_token from a session variable.
        my $moves = Net::Moves::V1->new(%args,
            access_token_data => $c->session->get('access_token'),
        );

        return $c->render('profile.tt', +{profile => $moves->user->profile});
    };

=head1 DESCRIPTION

This is a module for L<Moves API v1|https://dev.moves-app.com/docs/overview>.
A example of the whole process exists SYNOPSIS section.  You can know the
detail process in the official site.

=head1 METHODS

=over 4

=item new

The constructor. Options for initialization are listed below.

=over 4

=item client_id

=item client_secret

=item redirect_uri

These are items that you decided in L<developer site|https://dev.moves-app.com/clients>.
B<These are mandatory.>

=item mobile

This desides authorization url which the C<authorize> method will make.
B<This value is optional.> The default value is C<undef>, and so C<authorize>
method will make URI for PC app.

=item code

When a user access the authorization uri, the browser will access the callback
path in you app with C<code> parameter.

    ex. http://example.com/auth/moves/callback?code=abcde12345

For getting access token for this, you will need to specify C<code> argument
and use this C<code> parameter.

=item access_token

To access API with saved access token, you have to set thie argument.  If both
C<code> and C<access_token> are specified, only C<code> argument will be used.

=back

=item authorize

This will return a URI for authorization such as ...

    # for mobile
    moves://app/authoirze?client_id=XXXX&scope=activity

    # for PC
    https://api.moves-app.com/oauth/v1/authorize?response_type=code&client_id=XXXX&scope=activity

=over 4

=item redirect_uri

B<This is optional.>  If this is not set, C<< $self->redirect_uri >> will be
used.

=item scope

B<This is optional.>  It must have C<'activity'>, C<'location'>  or both with
C<' '> between parts.  If this is not set, C<'activity'> will be used.

=item state

B<This is optional.>  This will be returned as it is.

=back

=back

=head1 SEE ALSO

L<Net::Moves>, L<Net::OAuth2::Client>

=head1 AUTHOR

JINNOUCHI Yasushi, C<< <delphinus at remora.cx> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-moves at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Moves>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Moves


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Moves>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Moves>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Moves>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-Moves/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 JINNOUCHI Yasushi.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
