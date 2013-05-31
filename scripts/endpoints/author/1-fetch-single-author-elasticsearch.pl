#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use ElasticSearch;

my $es = ElasticSearch->new(
    no_refresh  => 1,
    servers     => 'api.metacpan.org',
#    trace_calls => \*STDOUT,
);

my $author = $es->get(
    index  => 'v0',
    type   => 'author',
    id => 'MSTROUT',
);

p $author;
