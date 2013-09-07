package Net::Moves;
use strict;
use warnings;
use Data::Util qw!:check!;
use Net::Moves::V1;

our $VERSION = '0.11';

sub new { my $class = shift; #{{{
    my $args = is_hash_ref($_[0]) ? $_[0] : +{@_};

    return Net::Moves::V1->new($args);
} #}}}

1; # End of Net::Moves

=head1 NAME

Net::Moves - Perl interface for Moves

=head1 VERSION

Version 0.11

=head1 SYNOPSIS

    use Net::Moves;

    my $moves = Net::Moves->new(
        client_id => 'abcdefg12345',
        client_secret => '12345abcdefg',
    );

=head1 DESCRIPTION

B<This is still BETA version!>

L<Moves|http://www.moves-app.com> is a life logging app for iPhone.
This is a Perl interface for L<Moves API|https://dev.moves-app.com/docs/overview>.

L<Net::Moves::V1> has the implements. Please see her documents.

C<sample> directory has a sample web app by L<Amon2::Lite>. You can try with
code below. (app.psgi depends on L<Amon2::Lite>, L<Date::Manip>.)

    $ export MOVES_CLIENT_ID=abcdefg123456
    $ export MOVES_CLIENT_SECRET=654321gfedcba
    $ plackup sample/app.psgi
    # and access http://0:5000/ with PC or iPhone.

=head1 METHODS

=over 4

=item new

The constructor. The arguments depends on L<Net::Moves::V1>;

=back

=head1 SEE ALSO

L<Net::Moves::V1>

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
