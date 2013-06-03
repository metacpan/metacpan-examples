#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use MetaCPAN::API;

my $mcpan = MetaCPAN::API->new;
my $html_pod = $mcpan->pod( module => 'Carton' );

say $html_pod;
