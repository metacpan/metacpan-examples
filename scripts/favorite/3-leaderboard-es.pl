#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use lib './lib';
use MetaCPAN::Util qw( es );

my $faves = es()->search(
    index => 'cpan',
    type  => 'favorite',
    body  => {
        aggs => {
            dist => {
                terms => { field => 'distribution', size => 10 },
            },
        },
    },
);

my @counts = map { +{ $_->{key} => $_->{doc_count} } }
    @{ $faves->{aggregations}->{dist}->{buckets} };
p @counts;

__END__
=pod

=head1 DESCRIPTION

Get the 10 distributions with the most ++ clicks, sorted by descending
popularity.

=cut
