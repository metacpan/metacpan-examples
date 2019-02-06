#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use CLDR::Number ();
use Cpanel::JSON::XS qw( decode_json );
use Data::Printer;
use List::Compare  ();
use LWP::UserAgent ();
use Math::Round qw( nearest );
use Parse::CPAN::Packages::Fast ();
use WWW::Mechanize::Cached      ();

my $cldr = CLDR::Number->new( locale => 'en' );
my $decf = $cldr->decimal_formatter;
my $perf = $cldr->percent_formatter( minimum_fraction_digits => 2 );

my @maxmind_authors = (
    'OALDERS',  'EILARA', 'TJMATHER', 'MATEU', 'OSCHWALD', 'RSRCHBOY',
    'FLORA',    'MARKF',  'RUBEN',    'WDS',   'KLPTWO',   'PCRONIN',
    'ANDYJACK', 'MAXMIND',
);
my @maxmind_redacted_authors = (
    'OALDERS', 'EILARA', 'TJMATHER', 'MATEU',  'OSCHWALD', 'RSRCHBOY',
    'MARKF',   'RUBEN',  'WDS',      'KLPTWO', 'PCRONIN',  'ANDYJACK',
);

my %PTS = (
    'qa2010' => [
        'CHORNY',   'HMBRAND',  'RURBAN',   'MARCEL',
        'BOOK',     'BDFOY',    'ANDYA',    'POTYL',
        'DAXIM',    'ABELTJE',  'OVID',     'HORNBURG',
        'DOMM',     'MIYAGAWA', 'PJCJ',     'BARBIE',
        'FLORA',    'RJBS',     'JKUTEJ',   'SREZIC',
        'MSCHWERN', 'SZABGAB',  'RGIERSIG', 'SQUEEK',
        'PEPL'
    ],
    'qa2011' => [
        'RGE',      'HMBRAND', 'MARCEL', 'SCHWIGON',
        'LEONT',    'BOOK',    'BDFOY',  'ANDYA',
        'AVAR',     'POTYL',   'DAXIM',  'ABELTJE',
        'SMUELLER', 'OVID',    'DOLMEN', 'WESJDJ',
        'SAPER',    'ADAMK',   'PJCJ',   'FLORA',
        'ABIGAIL',  'RJBS',    'PERLER', 'DGL',
        'JKUTEJ',   'WONKO',   'ADIE',   'BURAK'
    ],
    'qa2012' => [
        'XAV',      'HMBRAND',   'CHESSKIT', 'NPEREZ',
        'RGARCIA',  'ELIZABETH', 'DAGOLDEN', 'SCHWIGON',
        'LEONT',    'BOOK',      'BDFOY',    'ANDYA',
        'HAGGAI',   'GETTY',     'DAXIM',    'DDUMONT',
        'ABELTJE',  'OVID',      'ELBEHO',   'WOLFSAGE',
        'DOLMEN',   'WESJDJ',    'PAUAMMA',  'SAPER',
        'OALDERS',  'MIYAGAWA',  'PJCJ',     'BARBIE',
        'FLORA',    'VPIT',      'RJBS',     'DGL',
        'ISHIGAKI', 'WONKO',     'SREZIC',   'MSCHWERN',
        'GARU',     'RIBASUSHI', 'ADIE',     'APEIRON',
        'ANDK'
    ],
    'qa2013' => [
        'PERRETTDL', 'SJN',      'TBSLIVER',  'JROBINSON',
        'MITHALDU',  'HMBRAND',  'ELIZABETH', 'DAGOLDEN',
        'SCHWIGON',  'JKEENAN',  'LEONT',     'BOOK',
        'BANNAN',    'ANDYA',    'DREBOLO',   'PDCAWLEY',
        'GETTY',     'BINGOS',   'ABELTJE',   'REHSACK',
        'BYTEROCK',  'WOLFSAGE', 'DOLMEN',    'BBUSS',
        'PJCJ',      'BARBIE',   'ARC',       'RJBS',
        'DGL',       'ISHIGAKI', 'RIBASUSHI', 'JMASTROS',
        'ANDK',      'NEWELLC'
    ],
    'qa2014' => [
        'SJN',       'ETHER',    'MITHALDU', 'HMBRAND',
        'ELIZABETH', 'DAGOLDEN', 'SCHWIGON', 'LEONT',
        'BOOK',      'DAMS',     'MSTROUT',  'ABELTJE',
        'TIMB',      'FROGGS',   'OVID',     'REHSACK',
        'ELBEHO',    'WOLFSAGE', 'DOLMEN',   'SAPER',
        'OALDERS',   'PJCJ',     'BARBIE',   'RJBS',
        'ISHIGAKI',  'NEILB',    'SREZIC',   'RIBASUSHI',
        'HAARG',     'ANDK'
    ],
    'qa2015' => [
        'SJN',       'ETHER',     'MITHALDU',  'HMBRAND',
        'ELIZABETH', 'DAGOLDEN',  'SCHWIGON',  'LEONT',
        'EXODIST',   'BOOK',      'TADZIK',    'TINITA',
        'ABELTJE',   'INGY',      'FROGGS',    'REHSACK',
        'WOLFSAGE',  'DOLMEN',    'OALDERS',   'WOLLMERS',
        'MIYAGAWA',  'PJCJ',      'BARBIE',    'BARTOLIN',
        'RJBS',      'ISHIGAKI',  'NEILB',     'SREZIC',
        'DRTECH',    'RIBASUSHI', 'LICHTKIND', 'ARISTOTLE',
        'ANDK',      'NINE'
    ],
    'qa2016' => [
        'ETHER',    'HMBRAND', 'LLAP',      'ELIZABETH',
        'SCHWIGON', 'JKEENAN', 'LEONT',     'EXODIST',
        'BOOK',     'TADZIK',  'MICKEY',    'BINGOS',
        'ABELTJE',  'TIMB',    'JBERGER',   'WOLFSAGE',
        'DOLMEN',   'OALDERS', 'PJCJ',      'BARBIE',
        'ARC',      'RJBS',    'ISHIGAKI',  'XSAWYERX',
        'NEILB',    'SREZIC',  'ARISTOTLE', 'SARGIE',
        'ANDK'
    ],
    'qa2017' => [
        'ETHER',     'MITHALDU', 'HMBRAND',   'LEEJO',
        'LLAP',      'SKAJI',    'ELIZABETH', 'LEONT',
        'UGEXE',     'BOOK',     'TODDR',     'PREACTION',
        'TADZIK',    'MICKEY',   'BINGOS',    'TINITA',
        'ABELTJE',   'INGY',     'JBERGER',   'ELBEHO',
        'WOLFSAGE',  'OALDERS',  'MIYAGAWA',  'PJCJ',
        'ARC',       'ETJ',      'ISHIGAKI',  'XSAWYERX',
        'NEILB',     'SREZIC',   'GARU',      'ATOOMIC',
        'ARISTOTLE', 'HAARG',    'ANDK',      'NINE'
    ],
);

my $ua = LWP::UserAgent->new;
$ua->mirror( 'https://cpan.metacpan.org/modules/02packages.details.txt',
    '02packages.details.txt' );

my $parser = Parse::CPAN::Packages::Fast->new('02packages.details.txt');

say join '|',
    (
    q{},
    q{},
    'Modules with maint',
    'Modules in 02packages',
    '% of modules in 02packages',
    );
say join '---', ( ('|') x 5 );

for my $author ( sort @{$PTS{qa2017}} ) {
    crunch_numbers( $author, [$author]);
}

for my $group_name ( sort keys %PTS ) {
    crunch_numbers( $group_name, $PTS{$group_name} );
}

sub crunch_numbers {
    my $title   = shift;
    my $authors = shift;

    # The modules which these authors have release permissions on.
    my %perms = get_permissions($authors);

    my $lc = List::Compare->new( [ $parser->packages ], [ keys %perms ] );

    # The permissioned modules which actually appear in 02packages.
    my @covered = $lc->get_intersection;

    my $percent
        = nearest( 0.0001, scalar @covered / ( scalar $parser->packages ) );

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
