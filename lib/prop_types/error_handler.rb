# frozen_string_literal: true

module PropTypes
  #
  # Handler of errors -> raises the proper error, generates the message
  # Methods here should receive an error as argument,
  # or a number of variables needed to build a comprehensible error message
  class ErrorHandler
    NAME_ERROR_VARIABLE_REGEX = /undefined local variable or method \`(.*)\'/

    class << self
      def errors
        PropTypes::Errors
      end

      def handle_unexistant_variable(error)
        variable_name = variable_name_from_error(error)
        message =
          "Variable #{variable_name} was undefined, expected it to exist"
        raise errors::UnexistantVariable, message
      end

      def variable_name_from_error(e)
        e.original_message.match(NAME_ERROR_VARIABLE_REGEX)[1]
      end
    end
  end
end
