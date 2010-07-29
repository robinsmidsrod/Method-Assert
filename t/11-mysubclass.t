#!perl -T

use Test::More tests => 10;
use Test::Exception;
use Test::NoWarnings;

use lib 't/lib';

use MySubClass;

# Test class method (constructor)
lives_ok { MySubClass->new() } "MySubClass->new() should not die";
dies_ok { MySubClass->new->new } "new() as instance method should die";
dies_ok { MySubClass::new() } "Calling MySubClass::new() as a function should die because it doesn't exist";

# Test class method
lives_ok { MySubClass->instance_count() } "MySubClass->instance_count() should not die";
dies_ok { MySubClass->new->instance_count() } "instance_count() as instance method should die";
dies_ok { MySubClass::instance_count() } "Calling instance_count() as a function should die because it doesn't exist";

# Test instance method
lives_ok { MySubClass->new->output() } "Calling output() as an instance method should not die";
dies_ok { MySubClass->output() } "Calling output() as a class method should die";
dies_ok { MySubClass::output() } "Calling output() as a function should die";
