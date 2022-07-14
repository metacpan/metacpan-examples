package MetaCPAN::Util;

use strict;
use warnings;

use constant DEBUG => !!$ENV{METACPAN_EXAMPLES_DEBUG};

use Search::Elasticsearch;
use Sub::Exporter -setup => { exports => ['es'] };

sub es {
    return Search::Elasticsearch->new(
        client           => '2_0::Direct',
        cxn_pool         => 'Static::NoPing',
        nodes            => 'https://fastapi.metacpan.org/v1',
        send_get_body_as => 'POST',
        ( trace_to => 'Stdout' ) x !!(DEBUG),
    );
}

1;

=head1 NAME

MetaCPAN::Util - Utilities for accessing MetaCPAN

=head1 DESCRIPTION

Provides shared utility code for examples.

=head1 FUNCTIONS

=head2 es

Returns a L<Search::Elasticsearch> client configured for use with the
MetaCPAN API endpoint.

=head1 ENVIRONMENT

=over 4

=item C<METACPAN_EXAMPLES_DEBUG>

When set to C<1>, enables output of verbose debugging information.

=back

=cut
