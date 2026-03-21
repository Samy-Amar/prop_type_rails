# frozen_string_literal: true

module PropTypes
  #
  # Main logic -> Validation of class and blocks
  # Should include the various validating methods
  # Dispatches findings to errorhandler or other objects
  class Validator
    # rubocop:disable Lint/UnifiedInteger
    INTEGER_TYPES = if defined?(Fixnum)
                      [Fixnum, Bignum, Integer]
                    else
                      [Integer]
                    end
    # rubocop:enable Lint/UnifiedInteger

    TYPE_MAPPING = {
      string: [String],
      integer: INTEGER_TYPES,
    }.freeze
    ACCEPTABLE_TYPES = TYPE_MAPPING.keys

    class << self
      def prop_type_validation(prop_type, prop, &block)
        check_type_valid!(prop_type, prop)
        check_block_returns_true!(prop, &block)
      end

      def custom(prop_type, prop, &block)
        check_custom_type_valid!(prop_type, prop)
        check_block_returns_true!(prop, &block)
      end

      def check_custom_type_valid!(prop_type, prop)
        raise PropTypes::Errors::InvalidType unless prop.is_a?(prop_type)
      end

      def check_type_valid!(prop_type, prop)
        raise PropTypes::Errors::InvalidType unless type_valid?(prop_type, prop)
      end

      def check_block_returns_true!(prop)
        return unless block_given?
        raise PropTypes::Errors::FailedValidation unless yield(prop)
      end

      def type_valid?(prop_type, prop)
        TYPE_MAPPING[prop_type]&.include?(prop.class)
      end
    end
  end
end
