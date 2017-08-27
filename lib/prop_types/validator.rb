# frozen_string_literal: true

module PropTypes
  #
  # Main logic -> Validation of class and blocks
  # Should include the various validating methods
  # Dispatches findings to errorhandler or other objects
  class Validator
    TYPE_MAPPING = {
      string: [String],
      integer: [Fixnum, Bignum, Integer], # rubocop:disable Lint/UnifiedInteger
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
        raise PropTypes::InvalidType unless prop.class == prop_type
      end

      def check_type_valid!(prop_type, prop)
        raise PropTypes::InvalidType unless type_valid?(prop_type, prop)
      end

      def check_block_returns_true!(prop)
        return unless block_given?
        raise PropTypes::FailedValidation unless yield(prop)
      end

      def type_valid?(prop_type, prop)
        TYPE_MAPPING[prop_type]&.include?(prop.class)
      end
    end
  end
end
