#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Data::Printer;
use MetaCPAN::Util qw( es );

my $scroller = es()->scrolled_search(
    query  => { match_all => {} },
    filter => { term      => { 'author.profile.name' => 'twitter' } },
    search_type => 'scan',
    scroll      => '5m',
    index       => 'v0',
    type        => 'author',
    size        => 100,
);

while ( my $result = $scroller->next ) {
    my $author = $result->{_source};

    foreach my $profile ( @{ $author->{profile} } ) {
        next unless $profile->{name} eq 'twitter';

        say 'Tweet ' . $author->{pauseid} . ' @' . $profile->{id};
        last;
    }
}
