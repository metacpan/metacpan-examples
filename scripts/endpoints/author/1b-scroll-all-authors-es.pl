#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $scroller = es()->scrolled_search(
    query       => { match_all => {} },
    search_type => 'scan',
    scroll      => '5m',
    index       => 'v0',
    type        => 'author',
    size        => 100,
);

while ( my $result = $scroller->next ) {
    p $result->{_source};
}
