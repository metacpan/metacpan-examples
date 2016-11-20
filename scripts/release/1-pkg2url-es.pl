#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Search::Elasticsearch;

my $es = Search::Elasticsearch->new(
    cxn_pool => 'Static::NoPing',
    nodes    => 'https://fastapi.metacpan.org',
    trace_to => 'Stdout',
);

my $release = $es->search(
    index => 'cpan',
    type  => 'release',
    body  => {
        filter => { term => { 'archive' => 'Acme-Hoge-0.03.tar.gz' } },
    },
);

say $release->{hits}{hits}[0]{_source}{download_url};
