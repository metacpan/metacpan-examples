#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use MetaCPAN::Util qw( es );

my $scroller = es()->scroll_helper(
    search_type => 'scan',
    scroll      => '5m',
    index       => 'v0',
    type        => 'author',
    size        => 100,
    body        => {
        query => {
            filtered => {
                query => { term => { 'author.profile.name' => 'twitter' } },
            },
            match_all => {}
        }
    },
);

while ( my $result = $scroller->next ) {
    my $author = $result->{_source};

    foreach my $profile ( @{ $author->{profile} } ) {
        next unless $profile->{name} eq 'twitter';

        p 'Tweet ' . $author->{pauseid} . ' @' . $profile->{id};
        last;
    }
}
