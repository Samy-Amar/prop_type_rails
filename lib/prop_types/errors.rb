# frozen_string_literal: true

module PropTypes
  module Errors
    #
    # Error to raise when type does not have the same class as expected
    class InvalidType < StandardError
      DEFAULT_MESSAGE = 'Class of variable did not match expected class'
      def initialize(message = DEFAULT_MESSAGE); end
    end

    #
    # Error to raise when block passed equals to false
    class FailedValidation < StandardError
      DEFAULT_MESSAGE = 'Validation of block did not evaluate to true'
      def initialize(message = DEFAULT_MESSAGE); end
    end

    #
    # Error to raise when a variable was validated but didn't exist
    class UnexistantVariable < StandardError
      DEFAULT_MESSAGE = 'Inexistant variable name was called'
      def initialize(message = DEFAULT_MESSAGE); end
    end
  end
end
