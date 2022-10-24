## 2.0.0 (2022-10-24)

* Breaking: Update minimum versions of Ruby and RbNaCl
    * This also drops support for `rbnacl-libsodium`, which means libsodium is now required
      to be preinstalled on the OS level
    * Note: `#generate` expects named parameters, not a hash (which is important for Ruby 2.7+)

## 1.0.2 (2018-02-23)

* Use `Base.strict_encode64` to encode the secret key

## 1.0.1 (2017-02-07)

* Also catch `RbNaCl::LengthError` and wrap it in a `Base64Token::Error`

## 1.0.0 (2017-01-19)

* Initial release
