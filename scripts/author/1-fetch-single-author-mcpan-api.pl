#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::API;

my $mcpan  = MetaCPAN::API->new();
my $author = $mcpan->author('MSTROUT');

p $author;
