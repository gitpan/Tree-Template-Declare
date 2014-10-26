package Tree::Template::Declare::DAG_Node;
use strict;
use warnings;
use Carp;

our $VERSION='0.1';

sub new {
    my ($class,$node_class)=@_;
    $node_class||='Tree::DAG_Node';

    eval "require $node_class" or ## no critic (ProhibitStringyEval)
        croak "Can't load $node_class: $@";

    return bless {nc=>$node_class},$class;
}

sub new_tree {
    my ($self)=@_;

    return bless [],'Tree::Template::Declare::DAG_Node::Tree';
}

sub finalize_tree {
    my ($self,$tree)=@_;

    return $tree->[0];
}

sub new_node {
    my ($self)=@_;

    return $self->{nc}->new();
}

sub add_child_node {
    my ($self,$parent,$child)=@_;

    if ($parent->isa('Tree::Template::Declare::DAG_Node::Tree')) {
        push @{$parent},$child;
        return $parent;
    }
    return $parent->add_daughter($child);
}

sub set_node_name {
    my ($self,$node,$name)=@_;

    return $node->name($name);
}

sub set_node_attributes {
    my ($self,$node,$attrs)=@_;

    my %all_attributes=(
        %{$node->attributes},
        %{$attrs},
    );

    return $node->attributes(\%all_attributes);
}

1;
__END__

=head1 NAME

Tree::Template::Declare::DAG_Node

=head1 SYNOPSIS

See L<Tree::Template::Declare>.

=head1 SPECIFICITIES

This module will build trees using L<Tree::DAG_Node>. You can make it
use another module (assuming it has the same interface, for example
L<Tree::DAG_Node::XPath>) by passing the class name to the C<new>
method.

 use Tree::Template::Declare builder => '+DAG_Node'; # default

 use Tree::Template::Declare builder =>
     Tree::Template::Declare::DAG_Node->new('Tree::DAG_Node::XPath');
     # custom class

=head1 AUTHOR

Gianni Ceccarelli <dakkar@thenautilus.net>

=cut
