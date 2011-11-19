# vim:ts=4:sw=4:expandtab
package AnyEvent::HTTP::Stream;

# TODO: reconnecting/error handling

use strict;
use warnings;
use AnyEvent;
use AnyEvent::Util;
use AnyEvent::HTTP;
use Moose;

our $VERSION = '1.0';

has 'url' => (
    isa => 'Str',
    is => 'ro',
    required => 1,
);
has 'on_data' => (
    isa => 'CodeRef',
    is => 'ro',
    required => 1,
);
has 'on_keepalive' => (
    isa => 'CodeRef',
    is => 'ro',
    predicate => 'has_on_keepalive',
);
has '_guard' => (
    isa => 'Ref',
    is => 'rw',
);

sub BUILD {
    my ($self) = @_;
    http_request GET => $self->url,
        want_body_handle => 1,
        sub {
            my ($handle, $headers) = @_;

            return unless $handle;

            my $reader; $reader = sub {
                my ($handle, $data) = @_;

                if ($data) {
                    my $cb = $self->on_data;
                    $cb->($data);
                } else {
                    $self->on_keepalive() if $self->has_on_keepalive;
                }
                $handle->push_read(line => $reader);
            };
            $handle->push_read(line => $reader);
            $self->_guard(AnyEvent::Util::guard { $handle->destroy if $handle; undef $reader });
        };
}

1

__END__


=head1 NAME

AnyEvent::HTTP::Stream - Streaming HTTP with AnyEvent

=head1 DESCRIPTION

Unfinished. API might change.

=head1 VERSION

Version 0.1

=head1 AUTHOR

Michael Stapelberg, C<< <michael at stapelberg.de> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2010-2011 Michael Stapelberg.

This program is free software; you can redistribute it and/or modify it
under the terms of the BSD license.

=cut
