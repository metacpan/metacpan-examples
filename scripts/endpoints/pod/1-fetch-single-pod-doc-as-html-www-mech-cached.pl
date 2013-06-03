#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use WWW::Mechanize::Cached;
my $mech = WWW::Mechanize::Cached->new;

$mech->get('http://api.metacpan.org/v0/pod/Carton');

say $mech->content;
