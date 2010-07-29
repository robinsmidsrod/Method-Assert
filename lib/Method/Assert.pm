use strict;
use warnings;
package Method::Assert;

# ABSTRACT: Ensure instance or class methods are called properly

use Scalar::Util qw(blessed);
use Carp qw(confess);

sub import {
    my $package = caller();

    my $class_method = sub {
        if ( wantarray ) {
            # list context
            confess("Not called as an instance method") if blessed( $_[0] );
            return @_;
        }
        elsif ( defined wantarray ) {
            # scalar context
            my $first = shift;
            confess("Not called as an instance method") if blessed( $first );
            return $first;
        }
        else {
            # void context
            confess("Not called as an instance method") if blessed( $_[0] );
        }
    };

    my $instance_method = sub {
        if ( wantarray ) {
            # list context
            confess("Not called as an instance method") unless blessed( $_[0] );
            return @_;
        }
        elsif ( defined wantarray ) {
            # scalar context
            my $first = shift;
            confess("Not called as an instance method") unless blessed( $first );
            return $first;
        }
        else {
            # void context
            confess("Not called as an instance method") unless blessed( $_[0] );
        }
    };

    {
        no strict 'refs';
        *{ $package . '::class_method' } = $class_method;
        *{ $package . '::instance_method' } = $instance_method;
    }

    return 1;
}

=pod

=cut

1;
