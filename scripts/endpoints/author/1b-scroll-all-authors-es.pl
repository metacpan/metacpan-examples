#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $scroller = es()->scroll_helper(
    search_type => "scan",
    scroll      => "5m",
    index       => "v0",
    type        => "author",
    size        => 100,
    body => {
	query => {
		match_all =>  {} 
	}
   }
);

while ( my $result = $scroller->next ) {
    p $result->{_source};
}

=pod

=head1 DESCRIPTION

This script uses the Search::Elasticsearch::Scroll scrolling API.  It provides you with an
iterator and fetches new batches of results as the are needed.  This particular
example will iterate over every CPAN author.  The size is quite low, so that
you don't get overwhelmed with debugging data when first running this script.
For your purposes, you will likely want to try a greater size.  Depending on
your purposes, you may want to set a size of up to 5,000 in order to cut down
on the number of requests required to fetch all authors.

From the ElasticSearch documentation:

=over 4

The scroll parameter controls the keep alive time of the scrolling request and
initiates the scrolling process. The timeout applies per round trip (i.e.
between the previous scan scroll request, to the next).

=back

=cut
