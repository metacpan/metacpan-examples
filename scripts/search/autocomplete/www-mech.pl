#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use JSON::MaybeXS qw( decode_json );
use WWW::Mechanize::GZip ();

my $mech = WWW::Mechanize::GZip->new;

my $search_term = shift @ARGV || 'HTML::Re';

$mech->get(
    "https://fastapi.metacpan.org/v1/search/autocomplete?q=$search_term");
say $mech->content;

my $results = decode_json( $mech->content );

my @suggestions = map { $_->{fields} } @{ $results->{hits}->{hits} };
p @suggestions;

=pod

=head1 DESCRIPTION

/search/autocomplete is a convenience endpoint.  You GET this URL, providing a
query via the "q" param.  The response will be returned as JSON.  You will need
to fetch data from this endpoint via your own UserAgent as MetaCPAN::API does
not yet support it.

=cut
