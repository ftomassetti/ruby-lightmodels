require 'helper'
 
class TestOperations < Test::Unit::TestCase

  include TestHelper
  include CodeModels

  def test_class_decl_ext_class_in_module
    root = Ruby.parse("class TestOperations < Test::Unit::TestCase\nend")
  
    assert_right_class root, Ruby::ClassDecl
    assert_right_class root.super_class,Ruby::Constant
    assert_equal 'TestCase', root.super_class.name
    assert_right_class root.super_class.container,Ruby::Constant
    assert_equal 'Unit', root.super_class.container.name
    assert_right_class root.super_class.container.container,Ruby::Constant
    assert_equal 'Test', root.super_class.container.container.name
    assert_equal nil, root.super_class.container.container.container
  end

  def test_class_decl_ext_class_simple
    root = Ruby.parse("class Literal < Value\nend")

    assert_right_class root, Ruby::ClassDecl
    assert_equal Ruby.constant('Literal'),root.defname
    assert_equal 'Value', root.super_class.name
    assert_equal nil,root.super_class.container
  end

  def test_class_decl_no_ext
    root = Ruby.parse("class Literal\nend")

    assert_right_class root, Ruby::ClassDecl
    assert_equal nil,root.super_class
  end

  def test_class_with_nil_content
    root = Ruby.parse("class Literal\nnil\nend")

    assert_right_class root, Ruby::ClassDecl
    assert_equal 1,root.contents.count
    assert_right_class root.contents[0],Ruby::NilLiteral
  end

  def test_class_with_content
    root = Ruby.parse("class AClass\nattr_accessor :name\nend")

    assert_right_class root, Ruby::ClassDecl
    assert_equal nil,root.super_class
    assert_simple_const root.defname,'AClass'
    assert_equal 1,root.contents.count
    assert_right_class root.contents[0], Ruby::Call
  end

  def test_module
    root = Ruby.parse('module MyModule;end')

    assert_right_class root, Ruby::ModuleDecl
    assert_equal 0,root.contents.count
  end

  def test_self
    root = Ruby.parse('self')

    assert_node root, Ruby::Self
  end

  def test_singleton_class 
    r = Ruby.parse('class << self; end')

    assert_node r, Ruby::SingletonClassDecl, contents: [], object: Ruby::Self.new
  end

  def test_class_extending_struct
    r = Ruby.parse 'class Notifiable < Struct.new(:name, :parent); end'

    assert_node r, Ruby::ClassDecl
    assert_node r.super_class, Ruby::Call, name: 'new'
  end

end