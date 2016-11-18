# metacpan-examples

This repository contains sample code to get you up and running quickly with the MetaCPAN API.

## Please use MetaCPAN::Client

There are many different ways and clients which you can use to access the API.  However, *we strongly encourage you* to start by using the MetaCPAN::Client module.  If you have compelling reasons to use a different client, feel free to do so, but please be aware that MetaCPAN::Client is fully supported by MetaCPAN.  You will likely save yourself (and us) much debugging time if you begin with this module rather than rolling your own Elasticsearch queries.  If MetaCPAN::Client *doesn't* do something which you need it to do, please open a GitHub issue to let us know about it.

There are some examples to be found here which use `curl`, `WWW::Mechanize`, `Search::Elasticsearch` etc.  These are useful for reference, but please do take `MetaCPAN::Client` as your starting point. 

## Getting Started

Scripts are all found in /scripts.  You can run the Perl scripts in the usual manner,
but if you want to get up and running quickly, you are encouraged to run your
scripts via Carton.  The workflow is:

    cpanm Carton
    carton install
    bin/carton scripts/author/1a-search-authors.pl

Or, you can use Carton directly:

    carton exec perl -Ilib scripts/author/1a-search-authors.pl

Using the `bin/carton` will save you a few keystrokes and will
automatically add new libs to the path in future, if they are required.  Use
the workflow you are most comfortable with.

Please open issues for examples you would like to see and send pull requests
for examples you've already written.

## Upgrading from v0

The MetaCPAN API v1 is now available.  v0 will be deprecated after a 6 month window.  This window closes on or after June 1, 2017.  Here's a guide to converting your scripts.

## Elasticsearch version

v1 of the MetaCPAN API uses [Elasticsearch v2.4.0](https://www.elastic.co/guide/en/elasticsearch/reference/2.4/index.html) (v0 was at 0.20.2).  There are many breaking changes in this upgrade, since it spans almost 4 years.

The MetaCPAN API versions will increase with breaking changes, but we will not use the same versioning as Elasticsearch itself.

### Data Structure Changes

Elasticsearch 1.x changed the data structure returned when fields are used.
For example before one could get a `ArrayRef[ HashRef [ Str ] ]` where now
that will come in the form of `ArrayRef[ HashRef [ ArrayRef [ Str ] ] ]`.

Our convenience endpoints revert this behaviour, but if you're crafting your own searches, you should be aware that the structure of your fields data may have changed.

### Client-specific Changes

#### MetaCPAN::Client

v0:

```perl
use MetaCPAN::Client->new();
```

v1:

```perl
use MetaCPAN::Client->new( version => 'v1' );
```

#### Search::Elasticsearch

v0:

```perl
use Search::Elasticsearch;
my $es = Search::Elasticsearch->new(
    cxn_pool => 'Static::NoPing',
    nodes    => 'api.metacpan.org',
    trace_to => 'Stdout',
);
```

v1:

```perl
use Search::Elasticsearch;
my $es = Search::Elasticsearch->new(
    cxn_pool         => 'Static::NoPing',
    nodes            => 'https://fastapi.metacpan.org',
    send_get_body_as => 'POST',
    trace_to         => 'Stdout',
);
```

* The URL of the v1 API is https://fastapi.metacpan.org  Note that not only is the host name new, but we've also switched to https.

* You'll need to set `send_get_body_as => 'POST'`.  This is because v1 does not accept `GET` with a body.

##### $es->search

```perl
my $faves = $es->search(
    index => 'v0',
    type  => 'favorite',
    body  => {
        query  => { match_all => {} },
        facets => {
            dist => {
                terms => { field => 'favorite.distribution', size => 10 },
            },
        },
    },
    size => 0,
);
```

```perl
my $faves = es()->search(
    index => 'v1',
    type  => 'favorite',
    body  => {
        aggs => {
            dist => {
                terms => { field => 'distribution', size => 10 },
            },
        },
    },
);
``` 

* The index is now `v1`
* `match_all` is the default query type, so it's not required to specify it
* `facets` have been replaced by `aggs`
* The data structure returned for `facets` does not mirror the `aggs` return values, so you'll need to rework your logic when checking the return values.
* When searching on a type (`favorite` in this case), do not prefix the key with the type name.  So, as seen above, `field => 'favorite.distribution'` is now `field => 'distribution'`

#### GET via command line or browser

v0: `http://api.metacpan.org/v0/author/MSTROUT`

v1: `https://fastapi.metacpan.org/v1/author/MSTROUT`

* Note the new host name
* Note that we now use HTTPS
* Note that the path begins with v0 rather than v1