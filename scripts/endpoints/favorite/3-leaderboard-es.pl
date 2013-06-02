#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use DateTime;
use MetaCPAN::Util qw( es );

my $now = DateTime->now;
my $then = $now->clone->subtract( months => 1 );

my $faves = es()->search(
    index  => 'v0',
    type   => 'favorite',
    query  => { match_all => {} },
    facets => {
        dist =>
            { terms => { field => 'favorite.distribution', size => 10 }, },
    },
    size => 0,
);

my @dists = map { $_->{terms} } $faves->{facets}->{dist};

p @dists;
