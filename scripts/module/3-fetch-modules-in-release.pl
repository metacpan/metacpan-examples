use strict;
use warnings;
use feature qw( say );

use MetaCPAN::Client ();
my $client = MetaCPAN::Client->new( version => 'v1' );

my $dist = shift @ARGV;

die "usage: ./bin/carton $0 Moose" unless $dist;

my $modules = $client->module(
    {
        all => [
            { authorized   => 'true' },
            { binary       => 'false' },
            { distribution => $dist },
            { indexed      => 'true' },
            { status       => 'latest' },
        ]
    }
);

while ( my $module = $modules->next ) {
    next unless $module->module;
    for my $pkg ( @{ $module->module } ) {
        say $pkg->{name};
    }
}

