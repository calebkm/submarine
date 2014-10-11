class Submarine::Configuration

  # Acceptable accessors.
  attr_accessor :format_key, :left_delimiter, :right_delimiter, :substitutions

  # Constructs a new Configuration instance.
  # Merges passed in options hash, sets instance variables.
  #
  def initialize *attrs
    options = attrs.empty? ? {} : attrs.first
    options = self.class.defaults.merge(options)
    set_instance_variables options
  end

  # Configuration defaults.
  #
  def self.defaults
    {
      format_key:      :text, # The key representing the string to be formatted
      left_delimiter:  '[[',  # The left-side matching string, ie: '[[name]]'
      right_delimiter: ']]',  # The right-side matching string, ie: '[[name]]'
      substitutions:   {}     # Optional global default substitutions 
    }
  end

  # Reload the Configuration instance variables to defaults.
  #
  def reload!
    set_instance_variables(self.class.defaults)
  end

private

  # Set the instance variables from passed in options hash.
  #
  def set_instance_variables options
    @format_key      = options[:format_key].to_sym
    @left_delimiter  = options[:left_delimiter].to_s
    @right_delimiter = options[:right_delimiter].to_s
    @substitutions   = options[:substitutions]
  end

end