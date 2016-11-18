#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use JSON::MaybeXS qw( decode_json );
use WWW::Mechanize ();

my $mech = WWW::Mechanize->new;

$mech->get(
    'https://fastapi.metacpan.org/v1/search/reverse_dependencies/MIYAGAWA/carton-v0.9.13'
);

my $results = decode_json( $mech->content );

my @dists
    = map { $_->{_source}->{distribution} } @{ $results->{hits}->{hits} };
p @dists;
