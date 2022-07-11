#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use lib './lib';
use MetaCPAN::Util qw( es );

my $latest = es()->search(
    index  => 'cpan',
    type   => 'release',
    fields => [ 'distribution', 'version' ],
    size   => 4,
    body   => {
        query => {
            filtered => {
                filter => {
                    bool => {
                        must => [
                            { term => { 'status' => 'latest' } },
                            {
                                terms => {
                                    'distribution' => [
                                        'Moose',      'MetaCPAN-Client',
                                        'DBIx-Class', 'Moo',
                                    ]
                                },
                            },
                        ],
                        must_not => { term => { 'author' => 'ETHER' } },
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
