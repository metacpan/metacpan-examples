#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Util qw( es );

my $files = es()->search(
    index => 'cpan',
    type  => 'file',
    size  => 10,
    body  => {
        query => {
            filtered => {
                filter => {
                    and => [
                        { term => { 'path'      => 'cpanfile' } },
                        { term => { 'directory' => \0 } },
                    ]
                },
            },
        },
    },
    fields => [ 'release', 'author' ],
);

my @hits = @{ $files->{hits}->{hits} };
p @hits;
