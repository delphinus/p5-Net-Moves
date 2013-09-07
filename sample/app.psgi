use common::sense;
use Amon2::Lite;
use Data::Util qw!:check!;
use Date::Manip;
use FindBin;
#use Log::Minimal;
use Net::OAuth2::Client;
use Path::Class;

our $BASE_DIR;
BEGIN { $BASE_DIR = dir($FindBin::Bin); }
use lib $BASE_DIR->subdir(qw!extlib lib perl5!)->stringify;
use lib $BASE_DIR->subdir('lib')->stringify;
use lib $BASE_DIR->parent->subdir('lib')->stringify;

use Net::Moves;

our $VERSION = '0.01';

our $MOVES_CALLBACK_PATH = '/auth/moves/callback';

our $moves = Net::Moves->new(
    client_id => $ENV{MOVES_CLIENT_ID},
    client_secret => $ENV{MOVES_CLIENT_SECRET},
);

# put your configuration here
sub load_config { my $c = shift; #{{{
    +{
        'Text::Xslate' => +{
            function => +{
                UnixDate => sub { UnixDate @_; },
            },
        },
    }
} #}}}

get '/' => sub { my $c = shift; #{{{
    if ($c->session->get('access_token')) {
        return $c->render('index.tt');

    } else {
        my $is_mobile = $c->req->header('User-Agent') =~ /iPhone/;

        return $c->render('signin.tt', +{
            authorize_uri => $moves->authorize(mobile => $is_mobile),
        });
    }
}; #}}}

get '/moves/logout' => sub { my $c = shift; #{{{
    $c->session->set(access_token => undef);
    $c->redirect('/');
}; #}}}

get $MOVES_CALLBACK_PATH => sub { my $c = shift; #{{{
    my $uri = $c->req->uri;
    $uri->query_form(+{});

    # save access_token to a session variable.
    my $access_token = $moves->access_token(
        code => $c->req->param('code'),
        redirect_uri => $uri,
    );
    $c->session->set(access_token => $access_token->session_freeze);

    return $c->redirect('/');
}; #}}}

get '/moves/profile' => sub { my $c = shift; #{{{
    # get access_token from a session variable.
    my $user = $moves->user($c->session->get('access_token'));

    return $c->render('profile.tt', +{
        user_id => $user->id,
        profile => $user->profile,
    });
}; #}}}

get '/moves/recent' => sub { my $c = shift; #{{{
    # get access_token from a session variable.
    my $summary_daily = $moves->summary($c->session->get('access_token'));

    my $from = UnixDate '6 days ago' => '%Y%m%d';
    my $to = UnixDate today => '%Y%m%d';
    my %stash;
    $stash{data} = $summary_daily->range($from => $to);
    $stash{steps} = [map {
        my $summary = $_->{summary};
        is_array_ref($summary) ?
            (grep { $_->{activity} eq 'wlk' } @$summary)[0]->{steps} : 0;
    } @{$stash{data}}];

    return $c->render('recent.tt', \%stash);
}; #}}}

# load plugins
__PACKAGE__->enable_session;
__PACKAGE__->add_trigger(BEFORE_DISPATCH => sub { my $c = shift;
    $c->redirect('/') if $c->req->path_info =~ m!^/moves!
        && ! is_hash_ref $c->session->get('access_token');
});
#__PACKAGE__->enable_middleware('Log::Minimal', autodump => 1);

__PACKAGE__->to_app(handle_static => 1);
