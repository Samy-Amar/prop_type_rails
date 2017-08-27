# frozen_string_literal: true

# Version number
require 'prop_types/version'
# Main logic -> Validation of class and blocks
require 'prop_types/validator'
# Handler of errors -> raises the proper error, generates the message
require 'prop_types/error_handler'
# Different errors raised and their default messages
require 'prop_types/errors'

#
# Main lib - require everything here
module PropTypes
  puts "ifezjfiezjiofjzefjzefezjfezofjfi
  fjezfjpzefjoz
  fzefjzfjpofz
  efzejfjpfze
  fjzefjzeo
  fjezpfzofpe"
  #
  # Logic for methods like integer, string, etc.
  # Uses ACCEPTABLE_TYPES to define methods a nd call them
  def self.method_missing(*args, &block)
    super unless respond_to_missing?(args[0])
    Validator.prop_type_validation(*args, &block)
  end

  #
  # Will respond to missing
  # if the method name is included in the ACCEPTABLE_TYPES ary
  # (will respond to string, integer, etc.)
  def self.respond_to_missing?(method_name, include_private = false)
    Validator::ACCEPTABLE_TYPES.include?(method_name) || super
  end

  #
  # Validate types is a nice wrapper -> No real logic here
  def self.validate_types
    yield
  rescue NameError => e
    ErrorHandler.handle_unexistant_variable(e)
  end

  #
  # Similar to specs, describe will help compartiment code,
  # but not validate it
  def self.describe(_)
    yield
  end
end
