#!perl
use Test::Most 'die';
BEGIN {
eval 'use HTML::Element';
plan skip_all => 'HTML::Element needed for this test' if $@;
}
plan tests => 1;
use strict;
use warnings;
use Tree::Template::Declare builder => '+HTML_Element';
use Data::Dumper;

my $tree=tree {
    node {
        name 'html';
        node {
            name 'head';
            node {
                name 'title';
                text_node 'Page title';
            }
        };
        node {
            name 'body';
            node {
                name 'p';
                attribs id => 'p1';
                attribs class => 'para';
                text_node 'Page para';
            };
        };
    };
};

is($tree->as_HTML(),
   qq{<html><head><title>Page title</title></head><body><p class="para" id="p1">Page para</body></html>\n},
   'HTML tree'
);
