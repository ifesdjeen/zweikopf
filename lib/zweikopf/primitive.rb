require 'date'

module Zweikopf
  module Primitive
    def self.is_primitive_type?(obj)
      [String, Fixnum, Integer, Float, TrueClass, FalseClass, DateTime].include?(obj.class)
    end # self.is_primitive_type?
  end # Primitive
end # Zweikopf
