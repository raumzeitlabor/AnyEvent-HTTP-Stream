#!/usr/bin/env perl
# vim:ts=4:sw=4:expandtab
use strict;
use warnings;
use inc::Module::Install;

name     'AnyEvent-HTTP-Stream';
all_from 'lib/AnyEvent/HTTP/Stream.pm';

requires 'AnyEvent';
requires 'AnyEvent::HTTP';
requires 'Moose';

WriteAll;
