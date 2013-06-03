#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::API::Tiny;

my $mcpan  = MetaCPAN::API::Tiny->new();
my $author = $mcpan->author('MSTROUT');

p $author;
