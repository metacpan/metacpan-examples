#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $uploads = es()->search(
    index => 'v1',
    type  => 'release',
    body  => {
        query => { match_all => {} },
        aggs  => {
            author => { terms => { field => 'author', size => 10 }, },
        },
    },
);

my @authors = map { +{ $_->{key} => $_->{doc_count} } }
    @{ $uploads->{aggregations}->{author}->{buckets} };

p @authors;
