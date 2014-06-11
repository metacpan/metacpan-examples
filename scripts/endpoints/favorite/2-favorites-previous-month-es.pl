#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use DateTime;
use MetaCPAN::Util qw( es );

my $now = DateTime->now;
my $then = $now->clone->subtract( months => 1 );

my $faves = es()->search(
    index => 'v0',
    type  => 'favorite',
    body => {
    	query => {
    	    filtered => {
    	        query  => { match_all => {} },
    	        filter => {
    	            range => {
    	                'favorite.date' =>
    	                    { from => $then->datetime, to => $now->datetime }
    	            },
    	        },
    	    },
    	},
    },
    size => 400,
);

my @dists = map { $_->{_source} } @{ $faves->{hits}->{hits} };

p @dists;
