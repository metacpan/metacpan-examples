#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use HTTP::Tiny;

my $http = HTTP::Tiny->new(
    default_headers => { 'Content-Type' => 'text/plain' } );
say $http->get( 'http://api.metacpan.org/v0/pod/Carton' )->{content};
