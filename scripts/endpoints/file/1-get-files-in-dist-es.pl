#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Util qw( es );

my $files = es()->search(
    index => 'v0',
    type  => 'file',
    size  => 300,
    query => {
        filtered => {
            query  => { match_all => {} },
            filter => {
                bool => {
                    must => {
                        term => { 'file.release' => 'HTML-Restrict-2.1.5' },
                    },
                    must_not => { term => { 'file.directory' => 'true' }, },
                },
            },
        },
    },
);

my @files = sort map { $_->{_source}->{path} } @{ $files->{hits}->{hits} };
p @files;
