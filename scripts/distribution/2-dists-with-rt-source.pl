#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Client;

my $mc = MetaCPAN::Client->new( version => 'v1' );

my $search = $mc->all( 'distributions',
    { es_filter => { exists => { field => 'bugs.rt.source' } } } );

while ( my $dist = $search->next ) {
    p $dist;
}
