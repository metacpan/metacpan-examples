#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Util qw( es );

my @must = (
    { term => { 'release.resources.repository.type' => 'git' }, },
    { term => { status                              => 'latest' } },
    { term => { authorized                          => 'true' } },
);

my $scroller = es()->scrolled_search(
    query => {
        filtered => {
            query  => { match_all => {} },
            filter => { bool      => { must => \@must } },
        },
    },
    fields      => [ 'author', 'date', 'distribution', 'name', 'resources' ],
    search_type => 'scan',
    scroll      => '5m',
    index       => 'v0',
    type        => 'release',
    size        => 10,
);

while ( my $result = $scroller->next ) {
    my $release = $result->{_source};
}
