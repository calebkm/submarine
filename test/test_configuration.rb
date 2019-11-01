require 'minitest/autorun'
require 'submarine'

class Submarine::ConfigurationTest < Minitest::Test
  def setup
    @config = Submarine::Configuration.new
  end

  # Initialization
  # ---------------------------
  def test_instance_vars_and_accessors
    assert @config.respond_to?(:format_key)
    assert @config.respond_to?(:left_delimiter)
    assert @config.respond_to?(:right_delimiter)
    assert @config.respond_to?(:substitutions)
  end

  def test_config_defaults
    assert @config.format_key = Submarine::Configuration.defaults[:format_key]
    assert @config.left_delimiter = Submarine::Configuration.defaults[:left_delimiter]
    assert @config.right_delimiter = Submarine::Configuration.defaults[:right_delimiter]
    assert @config.substitutions = Submarine::Configuration.defaults[:substitutions]
  end

  def test_defaults_are_overrideable
    attrs = {format_key: 'copy', left_delimiter: '<<', right_delimiter: '>>', substitutions: {address: '9 Yellow Ave.'}}
    config = Submarine::Configuration.new(attrs)

    assert config.format_key = attrs[:format_key]
    assert config.left_delimiter = attrs[:left_delimiter]
    assert config.right_delimiter = attrs[:right_delimiter]
    assert config.substitutions = attrs[:substitutions]
  end

  # Class Methods
  # ---------------------------
  def test_defaults
   assert_equal Submarine::Configuration.defaults.class, Hash
   assert Submarine::Configuration.defaults[:format_key]
   assert Submarine::Configuration.defaults[:left_delimiter]
   assert Submarine::Configuration.defaults[:right_delimiter]
   assert Submarine::Configuration.defaults[:substitutions]
  end

  def test_substitutions_default
    assert_equal Submarine::Configuration.defaults[:substitutions].class, Hash
  end

  # Instance Methods
  # ---------------------------
  def test_reload!
    assert_equal @config.format_key, :text

    @config.format_key = :brand_new_key
    assert_equal @config.format_key, :brand_new_key

    @config.reload!
    assert_equal @config.format_key, :text
  end
end