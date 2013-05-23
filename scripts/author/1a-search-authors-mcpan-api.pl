#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::API;

my $mc = MetaCPAN::API->new;

my $search  = $mc->post(
    'author',
    {   query => { match_all => {} },
        size  => 5,
    },
);

say "raw results";
say '#'x80;
p $search;


say '#'x80;
say 'Total matches: ' . $search->{hits}->{total};

say "First result";
say '#'x80;
p $search->{hits}->{hits}->[0]->{_source};
