metacpan-examples
=================

Sample code to get you up and running quickly.

The purpose of this repository is to showcase how to use the MetaCPAN API.
There are examples using raw curl as well as the following Perl modules:
MetaCPAN::API, WWW::Mechanize and ElasticSearch.  Scripts are all found in
/scripts.  You can run the Perl scripts in the usual manner, but if you want to
get up and running quickly, you are encouraged to run your scripts via Carton.
The workflow is:

    cpanm Carton
    carton install
    ./bin/carton scripts/endpoints/author/1-fetch-single-author-mcpan-api.pl

Or, you can use Carton directly:

    carton exec -Ilib -- scripts/endpoints/author/1-fetch-single-author-mcpan-api.pl

Using the carton wrapper in bin will save you a few keystrokes and will
automatically new libs to the path, if required.  Use the workflow you are most
comfortable with.

Please open issues for examples you would like to see and send pull requests
for examples you've already written.
