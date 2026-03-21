# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PropTypes::Validator do
  describe '.check_type_valid!' do
    context 'with :string type' do
      it 'passes when value is a String' do
        expect { described_class.check_type_valid!(:string, 'hello') }.not_to raise_error
      end

      it 'raises InvalidType when value is an Integer' do
        expect { described_class.check_type_valid!(:string, 42) }
          .to raise_error(PropTypes::Errors::InvalidType)
      end

      it 'raises InvalidType when value is nil' do
        expect { described_class.check_type_valid!(:string, nil) }
          .to raise_error(PropTypes::Errors::InvalidType)
      end
    end

    context 'with :integer type' do
      it 'passes when value is an Integer' do
        expect { described_class.check_type_valid!(:integer, 42) }.not_to raise_error
      end

      it 'raises InvalidType when value is a String' do
        expect { described_class.check_type_valid!(:integer, 'hello') }
          .to raise_error(PropTypes::Errors::InvalidType)
      end

      it 'raises InvalidType when value is nil' do
        expect { described_class.check_type_valid!(:integer, nil) }
          .to raise_error(PropTypes::Errors::InvalidType)
      end
    end

    context 'with unknown type symbol' do
      it 'raises InvalidType when type is not in TYPE_MAPPING' do
        expect { described_class.check_type_valid!(:boolean, true) }
          .to raise_error(PropTypes::Errors::InvalidType)
      end
    end
  end

  describe '.check_custom_type_valid!' do
    let(:parent_class) { Class.new }
    let(:child_class) { Class.new(parent_class) }

    it 'passes when instance matches its exact class' do
      instance = parent_class.new
      expect { described_class.check_custom_type_valid!(parent_class, instance) }.not_to raise_error
    end

    it 'passes when a subclass instance is validated against a parent class' do
      instance = child_class.new
      expect { described_class.check_custom_type_valid!(parent_class, instance) }.not_to raise_error
    end

    it 'raises InvalidType when instance does not match expected class' do
      expect { described_class.check_custom_type_valid!(String, 42) }
        .to raise_error(PropTypes::Errors::InvalidType)
    end

    it 'passes when validating against a module the class includes' do
      test_module = Module.new
      test_class = Class.new { include test_module }
      instance = test_class.new
      expect { described_class.check_custom_type_valid!(test_module, instance) }.not_to raise_error
    end

    it 'raises InvalidType when value is nil' do
      expect { described_class.check_custom_type_valid!(String, nil) }
        .to raise_error(PropTypes::Errors::InvalidType)
    end
  end

  describe '.check_block_returns_true!' do
    it 'does not raise when no block is given' do
      expect { described_class.check_block_returns_true!('value') }.not_to raise_error
    end

    it 'does not raise when block returns truthy' do
      expect { described_class.check_block_returns_true!('value') { |v| v.is_a?(String) } }
        .not_to raise_error
    end

    it 'raises FailedValidation when block returns false' do
      expect { described_class.check_block_returns_true!('value') { |_v| false } }
        .to raise_error(PropTypes::Errors::FailedValidation)
    end

    it 'raises FailedValidation when block returns nil' do
      expect { described_class.check_block_returns_true!('value') { |_v| nil } }
        .to raise_error(PropTypes::Errors::FailedValidation)
    end

    it 'passes the prop value to the block' do
      received = nil
      described_class.check_block_returns_true!('test_value') { |v| received = v; true }
      expect(received).to eq('test_value')
    end

    it 'propagates exceptions raised inside the block' do
      expect {
        described_class.check_block_returns_true!('value') { raise ArgumentError, 'boom' }
      }.to raise_error(ArgumentError, 'boom')
    end
  end

  describe '.prop_type_validation' do
    it 'passes when type matches and no block given' do
      expect { described_class.prop_type_validation(:string, 'hello') }.not_to raise_error
    end

    it 'raises InvalidType when type does not match' do
      expect { described_class.prop_type_validation(:string, 42) }
        .to raise_error(PropTypes::Errors::InvalidType)
    end

    it 'passes when type matches and block returns true' do
      expect {
        described_class.prop_type_validation(:string, 'hello') { |v| v.length > 0 }
      }.not_to raise_error
    end

    it 'raises FailedValidation when type matches but block returns false' do
      expect {
        described_class.prop_type_validation(:string, 'hello') { |_v| false }
      }.to raise_error(PropTypes::Errors::FailedValidation)
    end

    it 'raises InvalidType before evaluating block when type is wrong' do
      block_called = false
      expect {
        described_class.prop_type_validation(:string, 42) { |_v| block_called = true; false }
      }.to raise_error(PropTypes::Errors::InvalidType)
      expect(block_called).to be false
    end
  end

  describe '.custom' do
    it 'passes when instance matches class and no block given' do
      expect { described_class.custom(String, 'hello') }.not_to raise_error
    end

    it 'raises InvalidType when instance does not match class' do
      expect { described_class.custom(String, 42) }
        .to raise_error(PropTypes::Errors::InvalidType)
    end

    it 'passes when instance matches and block returns true' do
      expect {
        described_class.custom(String, 'hello') { |v| v.length > 0 }
      }.not_to raise_error
    end

    it 'raises FailedValidation when instance matches but block returns false' do
      expect {
        described_class.custom(String, 'hello') { |_v| false }
      }.to raise_error(PropTypes::Errors::FailedValidation)
    end
  end
end
