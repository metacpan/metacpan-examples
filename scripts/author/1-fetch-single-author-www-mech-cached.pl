#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use WWW::Mechanize::Cached::GZip;
my $mech = WWW::Mechanize::Cached::GZip->new;
$mech->get('https://fastapi.metacpan.org/v1/author/MSTROUT');

say $mech->content;
