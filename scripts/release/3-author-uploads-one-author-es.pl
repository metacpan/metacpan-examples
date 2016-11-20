#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use MetaCPAN::Util qw( es );

my $uploads = es()->search(
    index => 'cpan',
    type  => 'release',
    body  => {
        query => {
            filtered => {
                filter => { term => { 'author' => 'OALDERS' } },
            },
        },
        aggs => {
            author => { terms => { field => 'author', size => 40 }, },
        },
    },
    size => 0,
);

use DDP;
p $uploads;
