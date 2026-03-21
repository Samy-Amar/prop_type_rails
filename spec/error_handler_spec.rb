# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PropTypes::ErrorHandler do
  def generate_name_error(var_name)
    eval(var_name) # rubocop:disable Security/Eval
  rescue NameError => e
    unless e.respond_to?(:original_message)
      # Ruby < 2.5 compatibility: alias original_message to message
      def e.original_message; message; end
    end
    e
  end

  describe '.variable_name_from_error' do
    it 'parses the variable name from a NameError' do
      error = generate_name_error('undefined_var')
      expect(described_class.variable_name_from_error(error)).to eq('undefined_var')
    end

    it 'parses a different variable name from a NameError' do
      error = generate_name_error('my_prop')
      expect(described_class.variable_name_from_error(error)).to eq('my_prop')
    end
  end

  describe '.handle_unexistant_variable' do
    it 'raises UnexistantVariable with the variable name in the message' do
      error = generate_name_error('some_variable')
      expect { described_class.handle_unexistant_variable(error) }
        .to raise_error(
          PropTypes::Errors::UnexistantVariable,
          'Variable some_variable was undefined, expected it to exist'
        )
    end
  end
end
