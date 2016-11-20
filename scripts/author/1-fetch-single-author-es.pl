#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Search::Elasticsearch;

my $es = Search::Elasticsearch->new(
    cxn_pool => 'Static::NoPing',
    nodes    => 'fastapi.metacpan.org',
    trace_to => 'Stdout',
);

my $author = $es->get(
    index => 'cpan',
    type  => 'author',
    id    => 'MSTROUT',
);

p $author;
