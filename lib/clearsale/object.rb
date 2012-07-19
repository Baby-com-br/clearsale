require 'ostruct'

module Clearsale
  class Object < OpenStruct
    def new_ostruct_member(name)
      name = name.to_sym
      unless self.respond_to?(name)
        class << self; self; end.class_eval do
          define_method(name) {
            v = @table[name]
            case v
              when Hash
                Object.new(v)
              when Array
                v.each_with_index { |item, index| v[index] = Object.new(item) }
              else
                v
              end
          }
          define_method("#{name}=") { |x| modifiable[name] = x }
          define_method("#{name}_as_a_hash") { @table[name] }
        end
      end
      name
    end
  end
end
