#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Util qw( es );

my $files = es()->search(
    index => 'cpan',
    type  => 'file',
    size  => 300,
    body  => {
        query => {
            filtered => {
                query  => { match_all => {} },
                filter => {
                    bool => {
                        must => {
                            term => { 'release' => 'HTML-Restrict-2.1.5' },
                        },
                        must_not => { term => { 'directory' => 'true' }, },
                    },
                },
            },
        },
    },
);

my @files = sort map { $_->{_source}->{path} } @{ $files->{hits}->{hits} };
p @files;
