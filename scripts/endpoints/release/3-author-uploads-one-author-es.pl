#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use DateTime;
use MetaCPAN::Util qw( es );

my $uploads = es()->search(
    index => 'v0',
    type  => 'release',
    query => {
        filtered => {
            query  => { match_all => {} },
            filter => { term      => { 'release.author' => 'OALDERS' } },
        },
    },
    facets => {
        author => { terms => { field => 'release.author', size => 40 }, },
    },
    size => 0,
);

say $uploads->{facets}->{author}->{terms}->[0]->{count};
