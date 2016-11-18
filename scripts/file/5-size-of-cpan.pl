#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Util qw( es );

my $search = es()->search(
    index => 'v1',
    type  => 'file',
    body  => {
        aggs => {
            size => { sum => { field => 'stat.size' } }
        },
        size => 0,
    },
);

say $search->{aggregations}{size}{value};

__END__
=pod

=head1 DESCRIPTION

Get the size of CPAN + BackPAN, when it's unpacked.

=cut
