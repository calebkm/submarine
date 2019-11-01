class Submarine
  # If no attributes are sent to Submarine.new, throw this.
  #
  class MissingAttributesError < StandardError
    def initialize(message = 'No attributes provided')
      super(message)
    end
  end

  # If no :format_key is sent to Submarine.new, throw this.
  #
  class MissingFormatKeyError < StandardError
    def initialize(message = 'No format key provided')
      super(message)
    end
  end
end