#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $latest = es()->search(
    index  => 'v0',
    type   => 'release',
    fields => [ 'distribution', 'version' ],
    size   => 3,
    body => {
    	query  => {
    	    filtered => {
    	        query  => { match_all => {} },
    	        filter => {
    	            bool => {
    	                must => [
    	                    { term => { 'release.status' => 'latest' } },
    	                    {   terms => {
    	                            'release.distribution' => [
    	                                'Moose', 'MetaCPAN-API',
    	                                'DBIx-Class'
    	                            ]
    	                        },
    	                    },
    	                ],
    	                must_not => { term => { 'release.author' => 'ETHER' } },
    	            },
    	        },
    	    },
    	},
    },
);

my @releases = map { $_->{fields} } @{ $latest->{hits}->{hits} };
p @releases;

=pod

=head1 DESCRIPTION

This example is much like the previous example, but in this case we've opted
for a "bool" filter rather than an "AND" filter.  The "bool" filter accepts the
following parameters: "must", "must_not" and "should".  Boolean filters are
preferred over AND, OR and NOT filters because they can make better choices
about how to combine filters optimally.

=cut
