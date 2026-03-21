# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PropTypes do
  describe 'VERSION' do
    it 'has a version number' do
      expect(PropTypes::VERSION).not_to be nil
    end
  end

  describe '.method_missing' do
    it 'delegates :string to Validator.prop_type_validation' do
      expect(PropTypes::Validator).to receive(:prop_type_validation)
        .with(:string, 'hello')
      PropTypes.string('hello')
    end

    it 'delegates :integer to Validator.prop_type_validation' do
      expect(PropTypes::Validator).to receive(:prop_type_validation)
        .with(:integer, 42)
      PropTypes.integer(42)
    end

    it 'passes a block through to Validator.prop_type_validation' do
      block = proc { |v| v.length > 0 }
      expect(PropTypes::Validator).to receive(:prop_type_validation) do |*, &blk|
        expect(blk).not_to be_nil
      end
      PropTypes.string('hello', &block)
    end

    it 'raises NoMethodError for methods not in ACCEPTABLE_TYPES' do
      expect { PropTypes.foobar }.to raise_error(NoMethodError)
    end
  end

  describe '.respond_to_missing?' do
    it 'returns true for :string' do
      expect(PropTypes.respond_to?(:string)).to be true
    end

    it 'returns true for :integer' do
      expect(PropTypes.respond_to?(:integer)).to be true
    end

    it 'returns false for :foobar' do
      expect(PropTypes.respond_to?(:foobar)).to be false
    end
  end

  describe '.validate_types' do
    it 'yields the given block' do
      called = false
      PropTypes.validate_types { called = true }
      expect(called).to be true
    end

    it 'rescues NameError and delegates to ErrorHandler' do
      expect {
        PropTypes.validate_types { undefined_variable_xyz }
      }.to raise_error(PropTypes::Errors::UnexistantVariable)
    end

    it 'does not rescue other exception types' do
      expect {
        PropTypes.validate_types { raise ArgumentError, 'test' }
      }.to raise_error(ArgumentError, 'test')
    end
  end

  describe '.describe' do
    it 'yields the given block' do
      called = false
      PropTypes.describe('section') { called = true }
      expect(called).to be true
    end

    it 'returns the result of the block' do
      result = PropTypes.describe('section') { 42 }
      expect(result).to eq(42)
    end
  end
end
