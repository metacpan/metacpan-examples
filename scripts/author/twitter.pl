#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use MetaCPAN::Client;

my $mc = MetaCPAN::Client->new( version => 'v1' );

# Search for authors with a listed Twitter account
my $search = $mc->author( { 'profile.name' => 'twitter' } );

my @handles;
while ( my $author = $search->next ) {

    # grep matching author profiles to extract only the Twitter id
    my @profiles = grep { $_->{name} eq 'twitter' } @{ $author->profile };

    foreach my $profile (@profiles) {
        my $id = $profile->{id};

        # not every handle returned by the API is prefixed by "@", so
        # we'll add it when it's missing
        $id = '@' . $id unless $id =~ m{\A@};
        push @handles, $id;
    }
}

# print a case-insensitive alpha-sorted list for humans to enjoy
say $_ for sort { "\L$a" cmp "\L$b" } @handles;

=pod

=head1 SYNOPSIS

To create your own Twitter list of CPAN authors install and configure
L<https://github.com/sferik/t>

Then run:

    t list create cpan-authors
    perl scripts/author/twitter.pl | xargs t list add cpan-authors
    t list cpan-authors members

=cut
