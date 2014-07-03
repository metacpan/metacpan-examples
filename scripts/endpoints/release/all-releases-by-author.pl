#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use DateTime;
use MetaCPAN::Util qw( es );

my $uploads = es()->search(
    index => 'v0',
    type  => 'release',
    body  => {
        query => {
            filtered => {
                query  => { match_all => {} },
                filter => { term      => { 'release.author' => 'OALDERS' } },
            },
        },
        fields => [ 'author', 'archive', 'date' ],
        sort => [ { "date" => "desc" } ],
    },
    size => 100,
);

my @releases = map { $_->{fields} } @{ $uploads->{hits}->{hits} };
use DDP;
p @releases;
