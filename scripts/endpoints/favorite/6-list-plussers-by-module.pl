#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use MetaCPAN::API;
use MetaCPAN::Util qw( es );

binmode( STDOUT, ":utf8" );

my $module_name = shift @ARGV;

die "Usage: ./bin/carton $0 HTML::Restrict\n" unless $module_name;

my $module = MetaCPAN::API->new->module( $module_name );

my $plussers = es()->search(
    index => 'v0',
    type  => 'favorite',
    size  => 1000,
    query => {
        filtered => {
            query  => { match_all => {} },
            filter => {
                term => { 'favorite.distribution' => $module->{distribution} }
            },
        },
    },
    fields => ['user'],
);

my @ids = map { $_->{fields}->{user} } @{ $plussers->{hits}->{hits} };
my $total = @ids;

my $authors = es()->search(
    index => 'v0',
    type  => 'author',
    size  => scalar @ids,
    query => {
        filtered => {
            query  => { match_all => {} },
            filter => { terms     => { 'author.user' => \@ids } },
        },
    },
    fields => [ 'pauseid', 'name' ],
    sort   => ['pauseid'],
);

foreach my $hit ( @{ $authors->{hits}->{hits} } ) {
    say $hit->{fields}->{pauseid} . ' - ' . $hit->{fields}->{name};
}

my $found = @{ $authors->{hits}->{hits} };
say "Found $found out of $total users";

=pod

=head1 DESCRIPTION

Given a module name, return the names of PAUSE author's who have clicked ++ on
the distribution this module belongs to.

=cut
