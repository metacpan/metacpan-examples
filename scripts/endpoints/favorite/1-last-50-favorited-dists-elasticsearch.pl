#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $faves = es()->search(
    index => 'v0',
    type  => 'favorite',
    query => { match_all => {} },
    sort  => [ { date => 'desc' } ],
    size  => 50,
);

my @dists = map { $_->{_source} } @{ $faves->{hits}->{hits} };

p @dists;
