java_import "clojure.lang.Keyword"

module Zweikopf
  module Keyword

    def self.from_ruby(keyword)
      ::Keyword.intern(keyword.to_s)
    end # self.from_ruby

    def self.from_clj(keyword)
      keyword.to_s.gsub(/:/, "").to_sym
    end # self.from_clj

  end # Keyword
end # Zweikopf
