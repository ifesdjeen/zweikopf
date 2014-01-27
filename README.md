# Zweikopf, a two-headed JVM friend of yours.
[![Continuous Integration status](https://secure.travis-ci.org/ifesdjeen/zweikopf.png)](http://travis-ci.org/ifesdjeen/zweikopf)

Zweikopf helps you to interoperate between Clojure and JRuby on JVM.

## Installation

Add this line to your application's Gemfile:

    gem 'zweikopf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zweikopf

For Clojure-driven projects, add this line to your `project.clj`:

```clojure
[zweikopf "0.4.0"]
```
## Usage

### From Ruby code: Clojure->Ruby transformations

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

### From Ruby code: Ruby->Clojure transformations

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

### Custom conversion

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

### From Clojure code:

With Clojure version everything is extremely simple:

```clojure
(:require 'zweikopf.core)

;; You _must_ call it, otherwise Ruby Runtime won't get initialized.
(init-ruby-context)

;; To convert Clojure DS to Ruby, run:
(rubyize {:a 1 :b 2})

;; To convert Ruby DS to Clojure, run
(clojurize ruby-obj)

;; If you want to execute arbitrary Ruby code, use ruby-eval:
(ruby-eval "puts 'Hello World'") ;; Or any other portion of Ruby code you'd like to execute

;; In order to require a file:
(ruby-require "filename")

;; In order to load:
(ruby-load "filename")

;; Call a method on a Ruby object:
;; This will call `#to_hash` method on `ruby-obj`
(call-ruby ruby-obj :to_hash)

;; To set gem-path:
(set-gem-path "my-gem-path")

;; To set gem-home:
(set-gem-path "my-gem-home")

;; To add custom convertor from Ruby to Clojure, extend protocol Clojurize
;; For example, convertion of RubyTime class to java Date
(extend-protocol Clojurize
  org.jruby.RubyTime
  (clojurize [this]
    (.toJava this java.util.Date)))

;; To add custom convertor from Clojure to Ruby, extend protocol Rubyize
;; For example, convertion of Clojure Keyword class to Ruby Symbol
(extend-protocol Rubyize
  clojure.lang.Keyword
  (rubyize [this]
    (.fastNewSymbol ruby-runtime (name this))))
```

# Pitfalls

When using Rails and DateTime conversion, you should call `DateTime#utc` before you can call `#to_time`.

It's very easy to package all your gems in a Jar, if you decide to do so, you need to either use
the files that were extracted by the runtime (which is by itself quite tricky, and you may run into
some issues with Bundler, if you use it), alternative is to materialize (extract) your gems from
jar manually. We're not yet ready to open our sorce for jar extraction, but you can write up your
own quite quickly, using `FileReader`, `JarFile` and `JarInputStream` files.

Other than that, JRuby/Clojure integration is very smooth and painless.

# Performance

We highly recommend using target language convertor. If you pass rather small data structures to Ruby scripts,
and return large portions back, use Clojure version. If you pass smaller amounts of data to Clojure code,
and it returns larger cunks, use Ruby version of transformer.

## Conversion from Ruby hash to Clojure PersistentHash Map

Most of time 52% according to the rough estimate is spent while converting from ruby Symbol to clojure Keyword.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Copyright

Copyright (C) 2012-2013 Alex Petrov and [contributors](https://github.com/ifesdjeen/zweikopf/graphs/contributors).

Distributed under the Eclipse Public License, the same as Clojure.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/ifesdjeen/zweikopf/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

