#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Client ();

my $mc = MetaCPAN::Client->new( version => 'v1' );

my $file = $mc->all(
    'files',
    {
        aggregations => { aggs => { sum => { field => 'stat.size' } } },
    }
);
p $file->aggregations;

__END__
=pod

=head1 DESCRIPTION

Get the size of CPAN + BackPAN, when it's unpacked.

=cut
