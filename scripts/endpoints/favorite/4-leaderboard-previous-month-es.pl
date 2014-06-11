#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use DateTime;
use MetaCPAN::Util qw( es );

my $now = DateTime->now;
my $then = $now->clone->subtract( months => 1 );

my $faves = es()->search(
    index => 'v0',
    type  => 'favorite',
    body  => {
        query => {
            filtered => {
                query  => { match_all => {} },
                filter => {
                    range => {
                        'favorite.date' =>
                            { from => $then->datetime, to => $now->datetime }
                    },
                },
            },
        },
        facets => {
            dist => {
                terms => { field => 'favorite.distribution', size => 50 },
            },
        },
    },
    size => 0,
);

my @dists = map { $_->{terms} } $faves->{facets}->{dist};

p @dists;
