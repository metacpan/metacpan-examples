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
    type   => 'release',
    query  => { match_all => {} },
    facets => {
        author =>
            { terms => { field => 'release.author', size => 40 }, },
    },
    size => 0,
);

my @dists = map { $_->{terms} } $faves->{facets}->{dist};

p @dists;

=pod

=DESCRIPTION

Because of the way facets are calculated, you may find that the numbers you get
towards the end of the list are not 100% accurate.  You can test this by
checking the results for position #10 with a size of 10 versus a size of 20.
So, if you need exact numbers for the leaderboard (and why wouldn't you?), you
should set a size greater than what you actually require.  You can experiment
with the size a bit to see the size required for the first X results to remain
consistent.

=cut
