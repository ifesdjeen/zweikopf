java_import "clojure.lang.PersistentVector"

module Zweikopf
  module Array

    def self.from_ruby(arr)
      PersistentVector.create(arr.inject([]) do |acc, v|
                                acc<< Zweikopf::Transformer.from_ruby(v)
                              end)
    end # to_persistent_vector

  end # Array
end # Zweikopf
