#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use HTTP::Tiny ();
use JSON::MaybeXS qw( encode_json );
use MetaCPAN::Util qw( es );

my $token   = shift @ARGV;
my @modules = @ARGV;

die "Usage: ./bin/carton $0 secret_token Moose DBIx::Class ...\n"
    unless @modules;

my $module = es()->search(
    index  => 'v1',
    type   => 'file',
    fields => 'release',
    size   => scalar @modules,
    body   => {
        query => {
            filtered => {
                filter => {
                    bool => {

                        # a module is a file
                        must => [
                            { term  => { 'authorized'  => 'true' } },
                            { terms => { 'module.name' => \@modules } },
                            { term  => { 'status'      => 'latest' } }
                        ]
                    },
                },
            },
        },
    },
);

my @release_names
    = map { $_->{fields}->{release} } @{ $module->{hits}->{hits} };

my $release = es()->search(
    index => 'v1',
    type  => 'release',
    size  => scalar @release_names,
    body  => {
        query => {
            filtered => {
                filter => { terms => { 'name' => \@release_names } },
            },
        },
    },
);

foreach my $hit ( @{ $release->{hits}->{hits} } ) {
    plus_plus(
        {
            author       => $hit->{_source}->{author},
            distribution => $hit->{_source}->{distribution},
            release      => $hit->{_source}->{name},
        }
    );
}

sub plus_plus {
    my $params = shift;
    my $ua     = HTTP::Tiny->new;
    my $res    = $ua->post(
        "https://api.metacpan.org/user/favorite?access_token=$token",
        {
            content => encode_json($params),
            headers => { 'content-type' => 'application/json' }
        },
    );
    p $res;
}

=pod

=head1 DESCRIPTION

Given a MetaCPAN secret token and a list of one or more modules, favorite these
in the user's MetaCPAN account.

See L<http://www.dagolden.com/index.php/2040/how-to-mass-favorite-modules-on-metacpan/>

=cut
