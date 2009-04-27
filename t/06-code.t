#!perl
use Test::Most tests => 2,'die';
use strict;
use warnings;
use Tree::Template::Declare builder => '+DAG_Node';
use Data::Dumper;

sub make_item {
    my ($name,$id)=@_;

    return detached node {
        name 'item';
        attribs id => $id;
        node {
            name 'description';
            attribs name => $name;
        };
    };
}

sub make_list {
    my (@items)=@_;

    my @item_nodes=map {make_item(@$_)} @items;

    return node {
        name 'list';
        attach_nodes @item_nodes;
    };
}

my $tree=tree {
    make_list([gino => 1],
              [pino => 2],
              [rino => 3],
          );
};

is_deeply($tree->tree_to_lol(),
          [
              [['description'],'item'],
              [['description'],'item'],
              [['description'],'item'],
              'list'],
          'tree with code');

my @attrs;
$tree->walk_down({callback=>sub{
                      push @attrs,$_[0]->attributes;
                      1
                  }});
is_deeply(\@attrs,
          [{},
           {id=>1},{name=>'gino'},
           {id=>2},{name=>'pino'},
           {id=>3},{name=>'rino'},
       ],
          'attributes');
