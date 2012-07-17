java_import "clojure.lang.PersistentHashMap"
java_import "clojure.lang.PersistentArrayMap"
java_import "clojure.lang.Keyword"
java_import "java.util.Map"

module Zweikopf
  module Hash
    def self.empty
      PersistentHashMap::EMPTY
    end

    def self.create(hash)
      ret = empty.as_transient
      hash.each do |k, v|
        if v.is_a?(::Hash)
          ret = ret.assoc(Keyword.intern(k.to_s), self.create(v))
        else
          ret = ret.assoc(Keyword.intern(k.to_s), v)
        end
      end
      ret.persistent
    end

    def self.from_clj(clj_hash)
      {}.tap do |ruby_map|
        clj_hash.each do |k, v|
          if v.is_a?(PersistentHashMap) || v.is_a?(PersistentArrayMap)
            ruby_map[clj_to_ruby_symbol(k)] = self.from_clj(v)
          else
            ruby_map[clj_to_ruby_symbol(k)] = v
          end
        end
      end
    end # self.from_clj

    def self.clj_to_ruby_symbol(keyword)
      keyword.to_s.gsub(/:/, "").to_sym
    end # self.clj_to_ruby_symbol
  end
end
