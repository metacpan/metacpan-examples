#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use JSON qw( decode_json );
use WWW::Mechanize;

my $mech = WWW::Mechanize->new;

my $search_term = shift @ARGV || 'HTML::Re';

$mech->get( "http://api.metacpan.org/search/autocomplete?q=$search_term" );
say $mech->content;

my $results = decode_json( $mech->content );

my @suggestions = map { $_->{fields} } @{ $results->{hits}->{hits} };
p @suggestions;
