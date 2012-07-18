java_import "clojure.lang.PersistentHashMap"
java_import "clojure.lang.PersistentArrayMap"
java_import "java.util.Map"

module Zweikopf
  module Hash
    def self.empty
      PersistentHashMap::EMPTY
    end

    def self.from_ruby(hash, &block)
      ret = empty.as_transient
      hash.each do |k, v|
        ret = ret.assoc(Keyword.from_ruby(k.to_s), Zweikopf::Transformer.from_ruby(v, &block))
      end
      ret.persistent
    end

    def self.from_clj(clj_hash)
      {}.tap do |ruby_map|
        clj_hash.each do |k, v|
          if v.is_a?(PersistentHashMap) || v.is_a?(PersistentArrayMap)
            ruby_map[Keyword.to_ruby(k)] = self.from_clj(v)
          else
            ruby_map[Keyword.to_ruby(k)] = v
          end
        end
      end
    end # self.from_clj

  end
end
