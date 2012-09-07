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

    def self.from_clj(clj_hash, &block)
      {}.tap do |ruby_map|
        clj_hash.each do |k, v|
          ruby_map[Keyword.from_clj(k)] = Zweikopf::Transformer.from_clj(v, &block);
        end
      end
    end # self.from_clj

  end
end
