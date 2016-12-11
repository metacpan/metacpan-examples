use strict;
use warnings;
use feature qw( say );

use MetaCPAN::Client ();

my $mc              = MetaCPAN::Client->new;
my $release_results = $mc->release(
    {
        all => [
            { author                      => 'NEILB', },
            { status                      => 'latest' },
            { 'resources.repository.type' => 'git' }
        ]
    }
);

while ( my $release = $release_results->next ) {
    say $release->resources->{repository}->{url};
}
