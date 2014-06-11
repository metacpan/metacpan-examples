#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use JSON qw( decode_json );
use MetaCPAN::Util qw( es );

my $search_term = shift @ARGV || 'HTML-Re';
if ( $search_term =~ m{::} ) {
    $search_term =~ s{::}{-}g;
}

my $result = es()->search(
    index => 'v0',
    type  => 'file',
    body =>
    {	
    query => {
        boosting => {
            negative_boost => 0.5,
            positive       => {
                bool => {
                    should => [
                        {
                            term => {
                                "file.documentation" => {
                                    boost => 20,
                                    value => $search_term,
                                }
                            }
                        },
                        {
                            term => {
                                "file.module.name" => {
                                    boost => 20,
                                    value => $search_term,
                                },
                            }
                        },
                        {
                            dis_max => {
                                queries => [
                                    {
                                        query_string => {
                                            allow_leading_wildcard => 0,
                                            boost                  => 3,
                                            default_operator       => "AND",
                                            fields                 => [
                                                "documentation.analyzed^2",
                                                "file.module.name.analyzed^2",
                                                "distribution.analyzed",
                                                "documentation.camelcase",
                                                "file.module.name.camelcase",
                                                "distribution.camelcase",
                                            ],
                                            query       => $search_term,
                                            use_dis_max => 1,
                                        },
                                    },
                                    {
                                        query_string => {
                                            allow_leading_wildcard => 0,
                                            default_operator       => "AND",
                                            fields                 => [
                                                "abstract.analyzed",
                                                "pod.analyzed"
                                            ],
                                            query       => $search_term,
                                            use_dis_max => 1,
                                        },
                                    },
                                ],
                            }
                        }
                    ]
                }
            },
            negative => {
                term => {
                    "file.mime" => { value => "text/x-script.perl" }
                }
            }
        }
    },
    },
    size => 10,
);

my @dists = map { $_->{_source} } @{ $result->{hits}->{hits} };

p @dists;

=pod

=head1 DESCRIPTION

This script will provide search result almost like on MetaCPAN main search [https://metacpan.org/search?q=$search_term]

=cut
