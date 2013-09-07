package Test::Net::Moves;
use common::sense;
use Test::Base -Base;

filters {
    input => [qw!yaml!],
    expected => [qw!yaml!],
};

package Test::Net::Moves::Filter;
use common::sense;
use Test::Base::Filter -Base;
use Module::Load;

use Test::More;

sub test_method { #{{{
    my $data = shift;
    my ($class, $method) = split ',', $self->current_arguments;

    load $class;

    no warnings 'redefine';
    *Net::OAuth2::Profile::WebServer::get_access_token = sub {
        my ($self, $code, @req_params) = @_;

        return Net::OAuth2::AccessToken->new(
            profile => $self,
            auto_refresh => !!$self->auto_save,
        );
    };

    my $obj = eval {
        my $tmp = $class->new(@{$data->{init}});
        return $method eq 'new' ? $tmp : $tmp->$method(@{$data->{args}});
    };
    my ($class_name, $error);
    $class_name = ref $obj if defined $obj;
    $error =~ s/ at .*? line \d+\.\n\z// if $error = $@;

    return +{class => $class_name, error => $error};
} #}}}
