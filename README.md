# Zweihopf, a two-headed JVM friend of yours.
[![Continuous Integration status](https://secure.travis-ci.org/ifesdjeen/zweikopf.png)](http://travis-ci.org/ifesdjeen/zweikopf)

Zweikopf helps you to interoperate between Clojure and JRuby on JVM.

## Installation

Add this line to your application's Gemfile:

    gem 'zweikopf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zweikopf

## Usage

Transfroming from Clojure entities to Ruby ones is as easy as:

```ruby
# Say you have a variable clojure_var that is a Clojure Hash: {:a 1 :b 2}
Zweikopf::Transformer.from_clj(clojure_var)
# => {:a => 1, :b => 2}

# Or an array: [1 2 3 4 5]
Zweikopf::Transformer.from_clj(clojure_var)
# => [1, 2, 3, 4, 5]

# Or something really wicked: {:a 1 :b {:c [{:d 2} {:e 3} {:f 4}]}}
Zweikopf::Transformer.from_clj(clojure_var)
# => {:a => 1, :b => {:c => [{:d => 2}, {:e => 3}, { :f => 4}]}}
```

And backwards:

```ruby
# Say you have a variable ruby_var that is a Ruby Hash: {:a => 1, :b => 2}
Zweikopf::Transformer.from_ruby(ruby_var)
# => {:a 1 :b 2}

# Or an array: [1, 2, 3, 4, 5]
Zweikopf::Transformer.from_ruby(ruby_var)
# => [1 2 3 4 5]

# Or something really wicked: {:a => 1, :b => {:c => [{:d => 2}, {:e => 3}, { :f => 4}]}}
Zweikopf::Transformer.from_ruby(ruby_var)
# => {:a 1 :b {:c [{:d 2} {:e 3} {:f 4}]}}
```

When performing Ruby to Clojure transformation, you may leave out some space for customization:

```ruby
class CustomTransformedEntry
  def serializable_hash
    {:c => 3, :d => 4}
  end
end

Zweikopf::Transformer.from_ruby({:a => 1, :b => CustomTransformedEntry.new }) do |v|
        if v.is_a?(CustomTransformedEntry)
          v.serializable_hash
        else
          v
        end
      end
# => {:a 1 :b {:c 3 :d 4}}
```

# Performance

## Conversion from Ruby hash to Clojure PersistentHash Map

Most of time 52% according to the rough estimate is spent while converting from ruby Symbol to clojure Keyword.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Copyright

Copyright (C) 2011-2012 Alex Petrov, Maximilian Karasz, Daniel Steiner, Roman Flammer.

Distributed under the Eclipse Public License, the same as Clojure.
