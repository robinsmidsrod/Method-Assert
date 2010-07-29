#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Method::Assert' );
}

diag( "Testing Method::Assert $Method::Assert::VERSION, Perl $], $^X" );
