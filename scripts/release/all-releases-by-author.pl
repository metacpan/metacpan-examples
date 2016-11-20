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
        fields => [ 'author', 'archive', 'date' ],
        sort => [ { "date" => "desc" } ],
    },
    size => 100,
);

my @releases = map { $_->{fields} } @{ $uploads->{hits}->{hits} };
use DDP;
p @releases;
