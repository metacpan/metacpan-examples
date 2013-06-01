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
    carton exec -- scripts/endpoints/author/1-fetch-single-author-mcpan-api.pl

Please open issues for examples you would like to see and send pull requests
for examples you've already written.
