#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use JSON::MaybeXS qw( decode_json );
use WWW::Mechanize::GZip ();

my $mech = WWW::Mechanize::GZip->new;

$mech->get(
    "https://fastapi.metacpan.org/v1/search/reverse_dependencies/carton");

my $results = decode_json( $mech->content );

my @dists
    = map { $_->{_source}->{distribution} } @{ $results->{hits}->{hits} };
p @dists;
