#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use WWW::Mechanize::Cached::GZip;
my $mech = WWW::Mechanize::Cached::GZip->new;
$mech->get('http://api.metacpan.org/v0/author/MSTROUT');

say $mech->content;
