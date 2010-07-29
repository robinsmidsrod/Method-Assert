#!perl -T

use Test::More tests => 5;
use Test::Exception;
use Test::NoWarnings;

use lib 't/lib';

use MyClass;

lives_ok { MyClass->new() } "MyClass->new() should not die";
dies_ok { MyClass->new->new } "new() as instance method should die";

lives_ok { MyClass->instance_count() } "MyClass->instance_count() should not die";
dies_ok { MyClass->new->instance_count() } "instance_count() as instance method should die";
