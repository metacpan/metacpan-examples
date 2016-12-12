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
    size   => 3,
    body   => {
        query => {
            filtered => {
                query  => { match_all => {} },
                filter => {
                    and => [
                        { term => { 'release.status' => 'latest' } },
                        {
                            terms => {
                                'release.distribution' =>
                                    [ 'Moose', 'MetaCPAN-API', 'DBIx-Class' ]
                            },
                        },
                    ],
                },
            },
        },
    }
);

my @releases = map { $_->{fields} } @{ $latest->{hits}->{hits} };
p @releases;

=pod

=head1 DESCRIPTION

This query uses an AND filter to get the latest release of Moose, MetaCPAN-API
and DBIx-Class.  Not that the "term" query is looking for an exact match on
"latest".  The "terms" query below it is looking for an exact match on *any* of
the release names in the list.  So, the "terms" query functions as an OR.  In
terms of SQL, you could write this logic using an "OR" or an "IN".

A release can have one of 3 valid status: latest, cpan or backpan.

=over 4

=item latest

This is the latest, authorized version of this release.

=item cpan

This release is currently on CPAN.  Check the "authorized" field if you want
only authorized releases.

=item backpan

This release is no longer on CPAN and is currently on BackPAN.  Check the
"authorized" field if you want only authorized releases.

=back

=cut
