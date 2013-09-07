use lib 't/lib';
use Test::Net::Moves;
plan tests => 1 * blocks;
run_is_deeply;

__DATA__

=== 'new' test -- valid - mobile
#{{{
--- input test_method=Net::Moves::V1,new
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde

--- expected
class: Net::Moves::V1
error: ''

#}}}

=== 'new' test -- valid - PC
#{{{
--- input test_method=Net::Moves::V1,new
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde

--- expected
class: Net::Moves::V1
error: ''

#}}}

=== 'new' test -- invalid - client_id
#{{{
--- input test_method=Net::Moves::V1,new
init:
  -
    client_id: ~
    client_secret: 12345abcde

--- expected
class: ~
error: "'client_id' must be a string."

#}}}

=== 'new' test -- invalid - client_secret
#{{{
--- input test_method=Net::Moves::V1,new
init:
  -
    client_id: abcde12345
    client_secret: ~

--- expected
class: ~
error: "'client_secret' must be a string."

#}}}

=== 'authorize' test -- valid - activity
#{{{
--- input test_method=Net::Moves::V1,authorize
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde
args:
  -
    scope: activity
    mobile: 1

--- expected
class: URI::_foreign
error: ''

#}}}

=== 'authorize' test -- valid - location
#{{{
--- input test_method=Net::Moves::V1,authorize
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde
args:
  -
    scope: location
    mobile: 1

--- expected
class: URI::_foreign
error: ''

#}}}

=== 'authorize' test -- valid - activity location
#{{{
--- input test_method=Net::Moves::V1,authorize
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde
args:
  -
    scope: location
    mobile: 1

--- expected
class: URI::_foreign
error: ''

#}}}

=== 'authorize' test -- valid - location activity
#{{{
--- input test_method=Net::Moves::V1,authorize
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde
args:
  -
    scope: location
    mobile: 1

--- expected
class: URI::_foreign
error: ''

#}}}

=== 'authorize' test -- invalid
#{{{
--- input test_method=Net::Moves::V1,authorize
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde
args:
  -
    scope: 'invalid scope'
    mobile: 1

--- expected
class: ~
error: "'scope' must be 'activity' or 'location' or 'activity location'."

#}}}

=== 'access_token' test -- valid - init with 'code'
#{{{
--- input test_method=Net::Moves::V1,access_token
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde
args:
  -
    redirect_uri: http://localhost:5000/autho/moves/callback
    code: abcdef123456abcdef

--- expected
class: Net::OAuth2::AccessToken
error: ''

#}}}

=== 'access_token' test -- valid - init with 'access_token_data'
#{{{
--- input test_method=Net::Moves::V1,access_token
init:
  -
    client_id: abcde12345
    client_secret: 12345abcde
    mobile: 1
    code: abcdef123456abcdef
args:
  -
    redirect_uri: http://localhost:5000/autho/moves/callback
    access_token_data: {}

--- expected
class: Net::OAuth2::AccessToken
error: ''

#}}}

# vim:se ft=yaml:
