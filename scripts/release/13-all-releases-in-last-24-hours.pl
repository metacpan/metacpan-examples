use strict;
use warnings;
use feature qw( say );

use DateTime         ();
use MetaCPAN::Client ();

my $now = DateTime->now;
my $then = DateTime->now->subtract( days => 1 );

my $mc = MetaCPAN::Client->new;

my $release_set = $mc->all(
    'releases',
    {
        es_filter => {
            range => { date => { from => $then->datetime } },
        },
    }
);

while ( my $release = $release_set->next ) {
    say $release->download_url;
}
