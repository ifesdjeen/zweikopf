module Zweikopf
  module Transformer

    def self.from_ruby(obj, &block)
      if Primitive.is_primitive_type?(obj)
        obj
      elsif obj.is_a?(::Hash)
        Hash.from_ruby(obj, &block)
      elsif obj.is_a?(::Array)
        Array.from_ruby(obj, &block)
      elsif obj.is_a?(::Symbol)
        Keyword.from_ruby(obj)
      elsif !block.nil?
        from_ruby(yield(obj))
      else
        obj
      end
    end # self.from_ruby

    def self.from_clj(obj, &block)
      return from_clj(yield(obj)) unless block.nil?
      case obj
        #TODO: primitve check
        when Keyword
          Keyword.from_clj(obj)
        when PersistentArrayMap
          Array.from_clj(obj)
        when PersistentHashMap
          Hash.from_clj(obj)
        else obj
      end
    end

  end # Transformer
end # Zweikopf
