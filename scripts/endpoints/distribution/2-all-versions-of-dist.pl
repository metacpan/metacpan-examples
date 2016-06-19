#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $dist = $ARGV[0]

my $releases = es()->get(
    index => 'v1',
    type  => 'release',
    body  =>
        {
            query => {
                filtered => {
                    query  => { match_all => {} },
                    filter => { term      => { distribution => $dist } }
                }
            },
            size => 1000,
            sort => [ { date => 'desc' } ],
            fields =>
                [qw( download_url name date author version version_numified
                status maturity authorized )],
        }
);

p $releases;



