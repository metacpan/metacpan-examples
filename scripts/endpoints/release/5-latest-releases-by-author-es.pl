#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $author = shift @ARGV;
die "usage: $0 PAUSEID" if !$author;

my $latest = es()->search(
    index  => 'v0',
    type   => 'release',
    fields => [ 'distribution', 'provides', 'version' ],
    size   => 500,
    body => {
    	query  => {
    	    filtered => {
    	        query  => { match_all => {} },
    	        filter => {
    	            and => [
    	                { term => { 'release.status' => 'latest' } },
    	                { term => { 'release.author' => [$author] }, },
    	            ],
    	        },
    	    },
    	},
    	sort => [ { 'release.date' => 'desc' } ],
    },
);

my @releases = map { $_->{fields} } @{ $latest->{hits}->{hits} };
p @releases;

=pod

=head1 DESCRIPTION

This query uses an AND filter to get the latest release by an AUTHOR.  Note
that since this is looking for "latest", it will only return releases for which
this author was the last to upload an authorized version.

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
