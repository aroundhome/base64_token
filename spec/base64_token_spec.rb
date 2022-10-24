# frozen_string_literal: true
require 'spec_helper'

describe Base64Token do
  before { described_class.encryption_key = described_class.generate_key }

  shared_examples 'valid encryption key' do
    it 'is able to perform a full roundtrip for a hash' do
      before = { foo: 'bar' }
      after = described_class.parse(described_class.generate(**before))
      expect(after).to eql(before)
    end

    it 'raises for a tampered token' do
      before = { foo: 'bar' }
      token = described_class.generate(**before)
      token.insert(5, '1337')
      expect { described_class.parse(token) }.to raise_error(Base64Token::Error)
    end
  end

  context 'with strict encoded key' do
    before { described_class.encryption_key = described_class.generate_key }

    it_behaves_like 'valid encryption key'
  end

  context 'with non-strict encoded key' do
    before do
      described_class.encryption_key = Base64.encode64(
        RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      )
    end

    it_behaves_like 'valid encryption key'
  end

  describe '#generate' do
    context ' when no encryption key is set' do
      before do
        described_class.encryption_key = nil
      end

      it 'raises an error' do
        expect { described_class.generate(foo: 'bar') }
          .to raise_error(Base64Token::ConfigurationError)
      end
    end
  end

  describe '#parse' do
    it 'returns an empty hash for nil' do
      expect(described_class.parse(nil)).to eql({})
    end

    it 'returns an empty hash for an empty string' do
      expect(described_class.parse('')).to eql({})
    end

    it 'raises an error for invalid Base64' do
      expect { described_class.parse('xxxxxxxxxxxxxx') }
        .to raise_error(Base64Token::Error)
    end

    it 'raises an error for invalid crypto box' do
      expect { described_class.parse('SSBhbSBwbGFpbiB0ZXh0') }
        .to raise_error(Base64Token::Error)
    end

    context ' when no encryption key is set' do
      before do
        described_class.encryption_key = nil
      end

      it 'raises an error' do
        expect { described_class.parse('abc') }
          .to raise_error(Base64Token::ConfigurationError)
      end
    end
  end
end
