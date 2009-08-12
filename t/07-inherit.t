#!perl
package Base;{
use strict;
use warnings;
use Tree::Template::Declare builder => '+DAG_Node';

sub doc {
    my ($self)=@_;
    tree {
        node {
            name 'doc';
            $self->head();
            $self->body();
        }
    }
}

sub head {
    node { name 'title' };
}

sub body {
    node {
        name 'content';
        $_[0]->content();
    }
}

sub content {
    node { name 'stuff' }
}

}

package Derived;{
use strict;
use warnings;
use Tree::Template::Declare builder => '+DAG_Node';
use base 'Base';

sub head {
    node { name 'whatever' };
    $_[0]->SUPER::head();
}

sub content {
    node { name 'something' }
}

}

package main;
use Test::Most tests=>2,'die';
use strict;
use warnings;

my $base_tree=Base->doc();

is_deeply($base_tree->tree_to_lol(),
          [['title'],[['stuff'],'content'],'doc'],
          'base tree');

my $deriv_tree=Derived->doc();

is_deeply($deriv_tree->tree_to_lol(),
          [['whatever'],['title'],[['something'],'content'],'doc'],
          'derived tree');
