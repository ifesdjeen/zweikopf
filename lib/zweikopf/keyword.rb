java_import "clojure.lang.Keyword"

module Zweikopf
  module Keyword

    def self.from_ruby(keyword)
      ::Keyword.intern(keyword.to_s)
    end # self.from_ruby

    def self.to_ruby(keyword)
      keyword.to_s.gsub(/:/, "").to_sym
    end # self.to_ruby

  end # Keyword
end # Zweikopf
