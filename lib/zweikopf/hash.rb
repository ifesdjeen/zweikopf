java_import "clojure.lang.PersistentHashMap"
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
        ret = ret.assoc(Keyword.intern(k.to_s), v)
      end
      ret.persistent
    end

  end
end
