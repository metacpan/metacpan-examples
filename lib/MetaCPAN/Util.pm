package MetaCPAN::Util;

use strict;
use warnings;

use Search::Elasticsearch;
use Sub::Exporter -setup => { exports => ['es'] };

sub es {
    return Search::Elasticsearch->new(
        cxn_pool         => 'Static::NoPing',
        nodes            => 'https://fastapi.metacpan.org/v1',
        send_get_body_as => 'POST',
        trace_to         => 'Stdout',
    );
}

1;
