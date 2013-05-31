#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use ElasticSearch;

my $es = ElasticSearch->new(
    no_refresh  => 1,
    servers     => 'api.metacpan.org',
    trace_calls => \*STDOUT,
);

my $module = $es->search(
    index  => 'v0',
    type   => 'file',
    query  => { match_all => {} },
    filter => {
        and => [
            { term => { 'file.module.name'    => 'Acme::Hoge' } },
            { term => { 'file.module.version' => '0.03' } }
        ]
    },
);

my $release_name = $module->{hits}{hits}[0]{_source}{release};

my $release = $es->search(
    index  => 'v0',
    type   => 'release',
    query  => { match_all => {} },
    filter => { term => { 'release.name' => $release_name } },
);

say $release->{hits}{hits}[0]{_source}{download_url};
