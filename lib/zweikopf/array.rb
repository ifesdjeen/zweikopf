java_import "clojure.lang.PersistentVector"

module Zweikopf
  module Array

    def self.from_ruby(arr)
      PersistentVector.create(arr.inject([]) do |acc, v|
                                acc<< Zweikopf::Transformer.from_ruby(v)
                              end)
    end # to_persistent_vector

    def self.from_clj(clj_vector)
      [].tap do |ruby_array|
        clj_vector.each do |v|
          if v.is_a?(PersistentHashMap) || v.is_a?(PersistentArrayMap)
            ruby_array << self.from_clj(v)
          else
            ruby_array << v
          end
        end
      end
    end

  end # Array
end # Zweikopf
