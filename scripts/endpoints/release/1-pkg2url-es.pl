#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Search::Elasticsearch;

my $es = Search::Elasticsearch->new(
    cxn_pool => 'Static::NoPing',
    nodes    => 'api.metacpan.org',
    trace_to => 'Stdout',
);

my $release = $es->search(
    index => 'v0',
    type  => 'release',
    body  => {
        query => { match_all => {} },
        filter =>
            { term => { 'release.archive' => 'Acme-Hoge-0.03.tar.gz' } },
    },
);

say $release->{hits}{hits}[0]{_source}{download_url};
