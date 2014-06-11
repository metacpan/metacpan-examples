#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $id = shift @ARGV;

die "usage: ./bin/carton $0 \$user_id" if !$id;

my $faves = es()->search(
    index => 'v0',
    type  => 'favorite',
    body => {
    	query => {
    	    filtered => {
    	        query  => { match_all => {} },
    	        filter => { term      => { 'favorite.user' => $id } }
    	    },
    	},
    	sort => [ { date => 'desc' } ],
    },
    size => 100,
);

my @dists = map { $_->{_source} } @{ $faves->{hits}->{hits} };

p @dists;
