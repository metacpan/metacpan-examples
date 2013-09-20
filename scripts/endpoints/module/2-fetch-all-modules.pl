#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( state );

use Data::Printer filters => { -external => ['JSON'] };
use MetaCPAN::Util qw( es );

# distributions which MetaCPAN has chosen not to include in its search index
# feel free to include these in your searches if you wish
my @ROGUE_DISTRIBUTIONS
    = qw(kurila perl_debug perl-5.005_02+apache1.3.3+modperl pod2texi perlbench spodcxx);

my $scroller = es()->scrolled_search(
    index  => 'v0',
    type   => 'file',
    query  => { "match_all" => {} },
    filter => {
        and => [
            {   not => {
                    filter => {
                        or => [
                            map { { term => { 'file.distribution' => $_ } } }
                                @ROGUE_DISTRIBUTIONS
                        ]
                    }
                }
            },
            { term => { status => 'latest' } },
            {   or => [

                    # we are looking for files that have no authorized
                    # property (e.g. .pod files) and files that are
                    # authorized
                    { missing => { field             => 'file.authorized' } },
                    { term    => { 'file.authorized' => \1 } },
                ]
            },
            {   or => [
                    {   and => [
                            { exists => { field => 'file.module.name' } },
                            { term => { 'file.module.indexed' => \1 } }
                        ]
                    },
                    {   and => [
                            { exists => { field => 'documentation' } },
                            { term => { 'file.indexed' => \1 } }
                        ]
                    }
                ]
            }
        ]
    },

    sort   => [                  { "date" => "desc" } ],
    fields => [ 'documentation', 'module' ],
    size   => 10,
);

# note that this search returns the names both of files which are pure
# documentation and also and arrayref of modules.  keep in mind that one file
# can contain many modules.  so, depending on your use case, you may want to
# deal with the documentation scalar, the module arrayref or even both.

while ( my $result = $scroller->next ) {
    state $counter = 0;
    $counter++;
    p $result->{fields};
    last if $counter == 10;
}
