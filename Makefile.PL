use inc::Module::Install;

name     'Tree-Template-Declare';
license  'perl';
all_from 'lib/Tree/Template/Declare.pm';

requires 'Carp'              => 0,
         'Sub::Exporter'     => 0,
         'Devel::Caller'     => 0,
         'perl'              => '5.6.0',
;

test_requires 'Test::Most'   => 0,
              'Tree::DAG_Node::XPath' => '0.10',
;

WriteAll;
