# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PropTypes::Errors do
  describe PropTypes::Errors::InvalidType do
    it 'inherits from StandardError' do
      expect(described_class).to be < StandardError
    end

    it 'has a default message' do
      error = described_class.new
      expect(error.message).to eq('Class of variable did not match expected class')
    end

    it 'accepts a custom message' do
      error = described_class.new('custom message')
      expect(error.message).to eq('custom message')
    end
  end

  describe PropTypes::Errors::FailedValidation do
    it 'inherits from StandardError' do
      expect(described_class).to be < StandardError
    end

    it 'has a default message' do
      error = described_class.new
      expect(error.message).to eq('Validation of block did not evaluate to true')
    end

    it 'accepts a custom message' do
      error = described_class.new('custom message')
      expect(error.message).to eq('custom message')
    end
  end

  describe PropTypes::Errors::UnexistantVariable do
    it 'inherits from StandardError' do
      expect(described_class).to be < StandardError
    end

    it 'has a default message' do
      error = described_class.new
      expect(error.message).to eq('Inexistant variable name was called')
    end

    it 'accepts a custom message' do
      error = described_class.new('custom message')
      expect(error.message).to eq('custom message')
    end
  end
end
