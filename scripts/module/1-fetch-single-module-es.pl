#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use lib './lib';
use MetaCPAN::Util qw( es );

my $module = es()->get(
    index => 'cpan',
    type  => 'module',
    id    => 'HTML::Restrict',
);

p $module;
