#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;

use lib './lib';
use MetaCPAN::Util qw( es );

my $author = es->get(
    index => 'cpan',
    type  => 'author',
    id    => 'MSTROUT',
);

p $author;
