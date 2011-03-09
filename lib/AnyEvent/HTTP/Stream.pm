# vim:ts=4:sw=4:expandtab
package AnyEvent::HTTP::Stream;

# TODO: reconnecting/error handling

use strict;
use warnings;
use AnyEvent;
use AnyEvent::Util;
use AnyEvent::HTTP;
use Moose;

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
