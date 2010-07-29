use strict;
use warnings;

{
    package MySubClass;
    use base 'MyClass';
    use Method::Assert;

    my $default_output_fh = \*STDERR;

    sub output_to {
        &instance_method;
        my $self = shift;
        $self->set_output_fh(shift);
        return $self->output(@_);
    }

    sub get_output_fh {
        my $self = &instance_method;
        return $self->{_FH} || $default_output_fh;
    }

    sub get_default_output_fh {
        &class_method;
        return $default_output_fh;
    }

    sub set_default_output_fh {
        my ($class, $fh) = &class_method;
        $default_output_fh = $fh;
    }

}

1;
