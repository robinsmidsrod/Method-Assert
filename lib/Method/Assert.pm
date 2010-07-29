use strict;
use warnings;
package Method::Assert;

# ABSTRACT: Ensure instance and class methods are called properly

use Scalar::Util qw(blessed);
use Carp qw(confess);

sub import {
    my $package = caller();

    my $class_method = sub {
        confess("Not called as a class method") if @_ == 0;
        if ( wantarray ) {
            # list context
            confess("Not called as a class method") if blessed( $_[0] );
            return @_;
        }
        elsif ( defined wantarray ) {
            # scalar context
            my $first = shift;
            confess("Not called as a class method") if blessed( $first );
            return $first;
        }
        else {
            # void context
            confess("Not called as a class method") if blessed( $_[0] );
        }
    };

    my $instance_method = sub {
        confess("Not called as an instance method") if @_ == 0;
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

=head1 SYNOPSIS

    package MyClass;

    use Method::Assert;
    use Carp qw(confess);

    sub new {
        my ($class, @args) = &class_method;
        my $self = {};
        bless $self, $class;
        $self->_init(@args);
        return $self;
    }

    sub _init {
        my ($self, @args) = @_; # Perl Critic prefers it this way
        &instance_method;       # still works
        ...
    }

    sub get_output_filename {
        &instance_method;
        return shift->{'output_filename'};
    }

    sub set_output_filename {
        my $self = &instance_method;
        confess("No parameter specified") unless @_;
        confess("File already exists") if -e $_[0];
        $self->{'output_filename'} = $_[0];
        return $self;
    }


=head1 DESCRIPTION

This module will export the two functions named below into the namespace of
the package using it. These two functions are useful to do typical checks at
the start of functions that are supposed to be either class or instance
methods.

B<Always remember to call these functions as C<&class_method> and
C<&instance_method>, or else they will not work properly!>

If you call them as C<class_method()> or C<instance_method()> a new version
of @_ will be initialized, and manipulation of @_ will not work properly.


=func class_method

Use this function to check that the sub is called as a class method. If the
sub is called as a function, or as an instance method this function will
die.

If called in scalar context, will shift of the first argument of the @_
array and return that value. If called in list or void context it will not
change @_.


=func instance_method

Use this function to check that the sub is called as an instance method. If
the sub is called as a function, or as a class method this function will
die.

If called in scalar context, will shift of the first argument of the @_
array and return that value. If called in list or void context it will not
change @_.


=head1 CAVEATS

The two functions can NOT be called by the fully qualified method name
because they are generated as closures in the calling package's namespace
during import(). Writing C<use Method::Assert ()> will cause import() not to
be executed, which doesn't not make sense. See the section on I<import> in
C<perldoc -f use> for more information.


=head1 SEMANTIC VERSIONING

This module uses semantic versioning concepts from L<http://semver.org/>.


=head1 SEE ALSO

=for :list
* L<Method::Signatures>
* L<Devel::Declare>
* L<MooseX::Method::Signatures>
* L<MooseX::Declare>

=cut

1;
