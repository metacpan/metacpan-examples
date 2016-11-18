#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use DateTime;
use MetaCPAN::Util qw( es );

my $now = DateTime->now;
my $then = $now->clone->subtract( months => 1 );

my $faves = es()->search(
    index => 'v1',
    type  => 'favorite',
    body  => {
        query => {
            filtered => {
                filter => {
                    range => {
                        date =>
                            { from => $then->datetime, to => $now->datetime }
                    },
                },
            },
        },
    },
    size => 400,
);

my @dists = map { $_->{_source} } @{ $faves->{hits}->{hits} };

p @dists;
