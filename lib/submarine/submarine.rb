class Submarine

  # Constructs a new Submarine instance.
  # Set instance variable and readers based on input hash.
  #
  def initialize *attrs
    raise MissingAttributesError unless attrs_provided?(attrs)
    raise MissingFormatKeyError unless attrs_includes_format_key?(attrs)

    attrs = attrs.first.merge(config.substitutions) # merge Configuration defaults

    attrs.each do |key, value|
      self.instance_variable_set("@#{key}", value) 
      self.class.class_eval{attr_reader key}
    end
  end

  # Destructively format the Submarine instance.
  # Returns the formatted string.
  #
  # Example:
  #   >> sub = Submarine.new(text: 'Hello, my name is [[name]].', name: 'Joe')
  #   => #<Submarine @text="Hello, my name is [[name]].", @name="Joe">
  #   >> sub.format!
  #   => "Hello, my name is Joe."
  #   >> sub
  #   => #<Submarine @text="Hello, my name is Joe.", @name="Joe">
  #
  # And, obviously, one line makes it more succinct:
  #   >> Submarine.new(text: 'Hello, my name is [[name]].', name: 'Joe').format!
  #   => "Hello, my name is Joe."
  #
  def format!
    substitutions.each{|s| sub_string.gsub!(match(s), replace(s))}
    sub_string
  end

  class << self
    # Global Submarine configuration getter.
    # Returns the current configuration options.
    # 
    # Example:
    #   >> Submarine.config
    #   => #<Submarine::Configuration @format_key=:text, @left_delimiter="[[", @right_delimiter="]]", @substitutions={}> 
    #
    def config
      @config ||= Configuration.new
    end

    # Global Submarine configuration setter.
    # The global default Submarine::Configuration options can be overwritten
    # by passing a block to config and setting new options.
    #
    # Example:
    #  # config/initializers/submarine.rb  <-- if you're using Rails, say
    #  Submarine.configure do |config|
    #    config.format_key = :copy
    #    config.left_delimiter = '<^'
    #    config.right_delimiter = '^>'
    #    config.substitutions = {company: 'Submarine Inc, Co'}
    #  end
    #
    #  >> Submarine.config
    #  => #<Submarine::Configuration @format_key=:copy, @left_delimiter="<^", @right_delimiter="^>", @substitutions={company: 'Submarine Inc, Co'}>
    # 
    def configure
      yield config
    end
  end

private

  # Were any attributes passed to Submarine.new?
  #
  def attrs_provided? attrs
    !attrs.empty?
  end

  # Was the :format_key attribute passed to Submarine.new?
  #
  def attrs_includes_format_key? attrs
    attrs.first.symbolize_keys.keys.include?(config.format_key.to_sym)
  end

  # Returns the string to be formatted.
  #
  # Example: 
  #   >> sub = Submarine.new(text: 'Format this string!')
  #   >> sub.send(:sub_string)
  #   => "Format this string!"
  #
  def sub_string
    instance_variable_get("@#{config.format_key}")
  end

  # Returns the string to match for gsub with passed in key.
  #
  # Example:
  #   >> sub = Submarine.new(text: 'Hello, my name is [[name]].', name: 'Joe')
  #   >> sub.send(:match, :name)
  #   => "[[name]]"
  #
  def match key
    "#{config.left_delimiter}#{key}#{config.right_delimiter}"
  end

  # Returns the replacement for gsub with passed in key.
  #
  # Example:
  #   >> sub = Submarine.new(text: 'Hello, my name is [[name]].', name: 'Joe')
  #   >> sub.send(:replace, :name)
  #   => "Joe"
  def replace key
    instance_variable_get("@#{key}").to_s
  end

  # Returns the global Submarine config.
  #
  # Example: 
  #   >> sub = Submarine.new(text: 'Hello, my name is [[name]].', name: 'Joe')
  #   >> sub.send(:config)
  #   => #<Submarine::Configuration @format_key=:text, @left_delimiter="[[", @right_delimiter="]]", @substitutions={}>
  #
  def config
    self.class.config
  end

  # Returns an array of symbols to use for matching.
  #
  # Example:
  #   >> sub = Submarine.new(text: 'Hello, my name is [[name]].', name: 'Joe')
  #   >> sub.send(:substitutions)
  #   => [:text, :name]
  #
  def substitutions
    subs = self.instance_variables
    subs.delete(config.format_key)
    subs.map{|s| s.to_s.gsub('@', '').to_sym}
  end

end