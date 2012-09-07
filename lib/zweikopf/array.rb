java_import "clojure.lang.PersistentVector"

module Zweikopf
  module Array

    def self.from_ruby(arr)
      PersistentVector.create(arr.inject([]) do |acc, v|
                                acc<< Zweikopf::Transformer.from_ruby(v)
                              end)
    end # to_persistent_vector

    def self.from_clj(clj_arr)
      [].tap do |ruby_arr|
        clj_arr.each do |v|
          ruby_arr<< Zweikopf::Transformer.from_clj(v);
        end
      end
    end # self.from_clj

  end # Array
end # Zweikopf
