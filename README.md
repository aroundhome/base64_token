[![Gem Version](https://badge.fury.io/rb/base64_token.svg)](https://badge.fury.io/rb/base64_token)
[![Build Status](https://travis-ci.org/kaeuferportal/base64_token.svg?branch=master)](https://travis-ci.org/kaeuferportal/base64_token)

# Base64Token

This gem allows you to take a ruby hash and turn it into an encrypted token
that you can later convert back to your original hash.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'base64_token'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install base64_token

## Usage

````ruby
# Set the encryption key used for your token. You should store that somewhere
# if you want to recognize your own tokens at a later time.
Base64Token.encryption_key = Base64Token.generate_key
=> "BgPrrt4Ltd7rYlsloSEs+cVuxcaLdjkTRFAjKWViIWo=\n"

token = Base64Token.generate(user_id: 42, valid_to: '2017-01-19T13:37:00')
=> "fTsJg-2iOA5F3YC2i5tlGcWUE-npnZwSEezA-yRfhLL8aV_KE6AuGIZH5YAdgE-lLhiNUmuWCFkxlgUJy7TjdmJFscxzeS-l3CTD1or6nwR0-zHA7B-Q"

Base64Token.parse(token)
=> {:user_id=>42, :valid_to=>"2017-01-19T13:37:00"}
````

Note that:

* your hash is converted to JSON intermediately, so you can (re)store anything
  that you can serialize to JSON
* to ensure consistency before and after deserialization, all hash keys have to be
  symbols

## Development

You can run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kaeuferportal/base64_token.
