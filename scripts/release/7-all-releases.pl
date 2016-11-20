#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Util qw( es );

my $scroller = es()->scroll_helper(
    search_type => 'scan',
    scroll      => '5m',
    index       => 'cpan',
    type        => 'release',
    size        => 1_000,
    body        => { fields => ['download_url'] },
);

my @urls;
while ( my $result = $scroller->next ) {
    push @urls, $result->{fields}->{download_url};
}
