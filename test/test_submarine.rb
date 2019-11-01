require 'minitest/autorun'
require 'submarine'

class SubmarineTest < Minitest::Test
  def setup
    Submarine.config.reload! # Reload the configuration to defaults

    @text      = "Hello, my name is [[name]]. I'm the CEO of [[company]]."
    @name      = "Joe"
    @company   = "Submarine Co, Inc"
    @submarine = Submarine.new(text: @text, name: @name, company: @company)
  end

  # Initialization
  #---------------------------
  def test_requires_attributes
    assert_raises(Submarine::MissingAttributesError) { Submarine.new }
  end

  def test_requires_format_key_attribute
    assert_raises(Submarine::MissingFormatKeyError) { Submarine.new(name: @name) }
  end

  def test_instance_vars_and_readers_created
    assert_send [@submarine, :text]
    assert_send [@submarine, :name]
    assert_send [@submarine, :company]
    assert_raises(NoMethodError) { @submarine.address }

    assert_equal @submarine.text, @text
    assert_equal @submarine.name, @name
    assert_equal @submarine.company, @company
  end

  # Instance Methods
  #---------------------------
  def test_format!
    assert_equal @submarine.format!, "Hello, my name is Joe. I'm the CEO of Submarine Co, Inc."
  end

  # Class Methods
  #---------------------------
  def test_config
    assert_equal Submarine.config.class, Submarine::Configuration
  end

  def test_configure
    assert_equal Submarine.config.format_key, Submarine::Configuration.defaults[:format_key]

    Submarine.configure {|config| config.format_key = :copy }
    assert_equal Submarine.config.format_key, :copy
  end

  # Private Methods
  #---------------------------
  def test_attrs_provided?
    assert @submarine.send(:attrs_provided?, [{name: @joe}])
    refute @submarine.send(:attrs_provided?, [])
  end

  def test_attrs_includes_format_key?
    assert @submarine.send(:attrs_includes_format_key?, [{text: @text}])
    refute @submarine.send(:attrs_includes_format_key?, [{name: @joe}])
  end

  def test_sub_string
    assert_equal @submarine.send(:sub_string), @text
    assert_equal @submarine.send(:sub_string), @submarine.text
  end

  def test_match
    assert_equal @submarine.send(:match, :name), '[[name]]'
  end

  def test_replace
    assert_equal @submarine.send(:replace, :name), @submarine.name
  end

  def test_config
    assert_equal @submarine.send(:config).class, Submarine::Configuration
  end

  def substitutions
    assert_equal @submarind.send(:substitutions), [:name, :company]
  end
end