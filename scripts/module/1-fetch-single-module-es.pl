#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $module = es()->get(
    index => 'v1',
    type  => 'module',
    id    => 'HTML::Restrict',
);

p $module;
