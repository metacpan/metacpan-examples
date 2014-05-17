package MetaCPAN::Util;

use strict;
use warnings;

use Search::Elasticsearch;
use Sub::Exporter -setup => { exports => ['es'] };

sub es {
    return Search::Elasticsearch->new(
        cxn_pool => "Static::NoPing",
        nodes     => "api.metacpan.org",
        trace_to => "Stdout",
    );
}

1;
