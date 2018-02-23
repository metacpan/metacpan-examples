use strict;
use warnings;
use feature qw( say );

use CLDR::Number ();
use Cpanel::JSON::XS qw( decode_json );
use Data::Printer;
use List::Compare ();
use Math::Round qw( nearest );
use Parse::CPAN::Packages::Fast ();
use WWW::Mechanize::Cached      ();

use CLDR::Number;
my $cldr = CLDR::Number->new( locale => 'en' );
my $decf = $cldr->decimal_formatter;
my $perf = $cldr->percent_formatter(minimum_fraction_digits => 2);

my @maxmind_authors = (
    'OALDERS',  'EILARA', 'TJMATHER', 'MATEU', 'OSCHWALD', 'RSRCHBOY',
    'FLORA',    'MARKF',  'RUBEN',    'WDS',   'KLPTWO',   'PCRONIN',
    'ANDYJACK', 'MAXMIND',
);
my @maxmind_redacted_authors = (
    'OALDERS', 'EILARA', 'TJMATHER', 'MATEU',  'OSCHWALD', 'RSRCHBOY',
    'MARKF',   'RUBEN',  'WDS',      'KLPTWO', 'PCRONIN',
    'ANDYJACK',
);
my @pts_authors = (
    'ABELJTE', 'ANDK', 'ARC', 'ARISTOTLE', 'ATOOMIC', 'BINGOS', 'BOOK',
    'ELBEHO',    'ELIZABETH', 'ETHER', 'GARU',   'HAARG',   'HMBRAND', 'INGY',
    'ISHIGAKI',  'JBERGER',   'LEEJO', 'LEONT',  'LLAP',    'MICKEY',
    'MITHALDU',  'MOHAWK',    'NEILB', 'NINE',   'OALDERS', 'PJCJ',
    'PREACTION', 'SARGIE',    'SKAJI', 'SREZIC', 'TADZIK',  'TINITA',
    'TODDR', 'UGEXE', 'WOLFSAGE', 'XSAWYERX',
);

my $parser = Parse::CPAN::Packages::Fast->new('02packages.details.txt');
crunch_numbers( 'MM+PTS', [ @maxmind_authors, @pts_authors ] );
crunch_numbers( 'PTS', \@pts_authors );
crunch_numbers( 'DROLSKY', ['DROLSKY'] );
crunch_numbers( 'MM', \@maxmind_authors );
crunch_numbers( 'ETHER+FLORA', [ 'ETHER', 'FLORA' ] );
crunch_numbers( 'ETHER',       ['ETHER'] );
crunch_numbers( 'FLORA',       ['FLORA'] );
crunch_numbers( 'MM-FLORA', \@maxmind_redacted_authors );
crunch_numbers( 'OALDERS', ['OALDERS'] );

sub crunch_numbers {
    my $title   = shift;
    my $authors = shift;
    my %perms   = get_permissions($authors);
    my $lc = List::Compare->new( [ $parser->packages ], [ keys %perms ] );
    my @covered = $lc->get_intersection;

    my $percent = nearest(
        0.0001,
        scalar @covered / ( scalar $parser->packages )
    );

    say join '|', $title, $decf->format( scalar keys %perms ),
        $decf->format( scalar @covered ), $perf->format($percent);
}

sub get_permissions {
    my $authors = shift;
    my $mech    = WWW::Mechanize::Cached->new;

    my %modules;

    my $base_url = 'http://fastapi.metacpan.org/v1/permission/by_author';
    foreach my $author ( @{$authors} ) {
        my $url = "$base_url/$author";
        $mech->get($url);
        my $perms = decode_json( $mech->content );

        foreach my $perm ( @{ $perms->{permissions} } ) {
            push @{ $modules{ $perm->{module_name} } }, $author;
        }
    }

    return %modules;
}
