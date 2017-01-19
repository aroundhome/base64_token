# frozen_string_literal: true
require 'base64_token/version'
require 'json'

require 'rbnacl/libsodium'
require 'rbnacl'

module Base64Token
  class Error < StandardError
  end

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
      JSON.parse(json).symbolize_keys
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
    rescue RbNaCl::CryptoError => e
      raise Error, e.message
    end

    def crypto_box
      RbNaCl::SimpleBox.from_secret_key(key)
    end

    def key
      @key ||= begin
        config = YAML.load_file('config/base64_token.yml')[Rails.env]
        Base64.decode64(config['secret_key'])
      end
    end
  end
end
