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

  end # Transformer
end # Zweikopf
