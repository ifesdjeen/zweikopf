# Zweihopf, a two-headed JVM friend of yours.

Zweikopf helps you to interoperate between Clojure and JRuby on JVM.

## Installation

Add this line to your application's Gemfile:

    gem 'zweikopf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zweikopf

# Performance

## Conversion from Ruby hash to Clojure PersistentHash Map

Most of time 52% according to the rough estimate is spent while converting from ruby Symbol to clojure Keyword.

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Copyright

Copyright (C) 2011-2012 Alex Petrov, Maximilian Karasz, Daniel Steiner, Roman Flammer.

Distributed under the Eclipse Public License, the same as Clojure.
