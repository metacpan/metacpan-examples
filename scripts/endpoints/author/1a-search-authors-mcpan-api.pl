#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Client;
use Search::Elasticsearch::Scroll;

my $mc = MetaCPAN::Client->new;

my $search  = $mc->author({name => 'Olaf *'});

say "raw results";
say '#'x80;
p $search;

say '#'x80;
say 'Total matches: ' . $search->total;
