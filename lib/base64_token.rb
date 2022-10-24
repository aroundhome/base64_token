# frozen_string_literal: true
require 'base64'
require 'base64_token/version'
require 'json'

require 'rbnacl'

module Base64Token
  class Error < StandardError; end
  class ConfigurationError < StandardError; end

  class << self
    def generate(**hash)
      json = JSON.generate(hash)
      cipher = encrypt(json)
      Base64.urlsafe_encode64(cipher)
    end

    def parse(token)
      return {} if !token || token.strip.empty?
      cipher = base64_decode(token)
      json = decrypt(cipher)
      JSON.parse(json).map { |k, v| [k.to_sym, v] }.to_h
    end

    def generate_key
      Base64.strict_encode64(
        RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      )
    end

    def encryption_key=(key)
      @encryption_key = key
      @crypto_box = nil
    end

    private

    def encrypt(plaintext)
      crypto_box.encrypt(plaintext)
    end

    def base64_decode(string)
      Base64.urlsafe_decode64(string)
    rescue ArgumentError => e
      raise Error, e.message
    end

    def decrypt(ciphertext)
      crypto_box.decrypt(ciphertext)
    rescue RbNaCl::CryptoError, RbNaCl::LengthError => e
      raise Error, e.message
    end

    def crypto_box
      @crypto_box ||= begin
        unless @encryption_key
          raise ConfigurationError, 'Encryption key not set.'
        end

        key = Base64.decode64(@encryption_key)
        RbNaCl::SimpleBox.from_secret_key(key)
      end
    end
  end
end
