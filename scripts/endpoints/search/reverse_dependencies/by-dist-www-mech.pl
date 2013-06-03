#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use JSON qw( decode_json );
use WWW::Mechanize;
my $mech = WWW::Mechanize->new;

$mech->get( "http://api.metacpan.org/v0/search/reverse_dependencies/carton" );

my $results = decode_json( $mech->content );

my @dists
    = map { $_->{_source}->{distribution} } @{ $results->{hits}->{hits} };
p @dists;
