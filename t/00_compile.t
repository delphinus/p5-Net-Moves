use common::sense;
use Test::More;

BEGIN {
    my @modules = qw!
        Net::Moves
        Net::Moves::V1
    !;
    plan tests => scalar @modules;
    use_ok $_ for @modules;
}

diag( "Testing Net::Moves $Net::Moves::VERSION, Perl $], $^X" );
