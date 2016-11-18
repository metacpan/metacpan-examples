#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Client;

my $mc = MetaCPAN::Client->new( version => 'v1' );

my $search = $mc->author( { name => 'Olaf *' } );

say "raw results";
say '#' x 80;
while ( my $author = $search->next ) {
    p $author;
}

say '#' x 80;
say 'Total matches: ' . $search->total;
