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

my $module = $es->search(
    index => 'v0',
    type  => 'file',
    body  => {
        query  => { match_all => {} },
        filter => {
            and => [
                { term => { 'file.authorized'     => 'true' } },
                { term => { 'file.module.name'    => 'Acme::Hoge' } },
                { term => { 'file.module.version' => '0.03' } }
            ]
        },
    },
);

my $release_name = $module->{hits}{hits}[0]{_source}{release};

my $release = $es->search(
    index => 'v0',
    type  => 'release',
    body  => {
        query  => { match_all => {} },
        filter => { term      => { 'release.name' => $release_name } },
    },
);

say $release->{hits}{hits}[0]{_source}{download_url};
