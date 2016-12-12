#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use lib './lib';
use MetaCPAN::Util qw( es );

my $release = es->search(
    index => 'cpan',
    type  => 'release',
    body  => {
        filter => { term => { 'archive' => 'Acme-Hoge-0.03.tar.gz' } },
    },
);

say $release->{hits}{hits}[0]{_source}{download_url};
