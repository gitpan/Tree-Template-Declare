package Tree::Template::Declare::HTML_Element;
use strict;
use warnings;
use Carp;
use HTML::Element;

our $VERSION='0.5';

sub new {
    my ($class)=@_;

    return bless {},$class;
}

sub _munge_exports {
    my ($self,$exports)=@_;

    my %all_exports=(
        %{$exports},
        text_node => sub($) {
            $exports->{node}->(
                sub {
                    $exports->{name}->('~text');
                    $exports->{attribs}->(text => $_[0]);
                });
        },
    );

    return \%all_exports;
}

sub new_tree {
    my ($self)=@_;

    return bless [],'Tree::Template::Declare::HTML_Element::Tree';
}

sub finalize_tree {
    my ($self,$tree)=@_;

    my $dom=$tree->[0];
    $dom->deobjectify_text();
    return $dom;
}

sub new_node {
    my ($self)=@_;

    return HTML::Element->new('~comment');
}

sub add_child_node {
    my ($self,$parent,$child)=@_;


    if ($parent->isa('Tree::Template::Declare::HTML_Element::Tree')) {
        push @{$parent},$child;
        return $parent;
    }
    return $parent->push_content($child);
}

sub set_node_name {
    my ($self,$node,$name)=@_;

    return $node->tag($name);
}

sub set_node_attributes {
    my ($self,$node,$attrs)=@_;

    while (my ($name,$val)=each %{$attrs}) {
        $node->attr($name, $val);
    }
    return;
}

1;
__END__

=head1 NAME

Tree::Template::Declare::HTML_Element

=head1 SYNOPSIS

See L<Tree::Template::Declare>.

=head1 SPECIFICITIES

This module will build trees using L<HTML::Element>.

To create text nodes, you would be forced to say:

  node {
    name '~text';
    attribs text => 'some text';
  }

which is too cumbersone. You can instead use:

  text_node 'some text';

HTML::Element's C<deobjectify_text> method will be called by
C<finalize_tree> before returning the tree object.

=head1 AUTHOR

Gianni Ceccarelli <dakkar@thenautilus.net>

=cut
