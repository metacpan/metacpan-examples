#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use ElasticSearch;

my $es = ElasticSearch->new(
    no_refresh => 1,
    servers    => 'api.metacpan.org',
    trace_calls => \*STDOUT,
);

my $release = $es->search(
    index  => 'v0',
    type   => 'release',
    query  => { match_all => {} },
    filter => { term => { 'release.archive' => 'Acme-Hoge-0.03.tar.gz' } },
);

say $release->{hits}{hits}[0]{_source}{download_url};
