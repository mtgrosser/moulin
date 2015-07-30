module Moulin
  class Base
    
    class << self
      
      def api_path(*args)
        raise ArgumentError, "Wrong number of arguments (#{args.size} for 1)" if args.size > 1
        "#{name.split('::').last.downcase}s/#{args.first}"
      end
      
      def attribute(*attrs)
        attrs.each do |attr|
          define_method(attr) { read_attribute(attr) }
          define_method("#{attr}=") { |value| write_attribute(attr, value) }
        end
      end
      
      def updatable
        include Operations::Update
      end
      
      def destroyable
        include Operations::Destroy
      end
      
    end
    
    attribute :id
    
    def initialize(api, attrs = {})
      raise ArgumentError, "#{api.inspect} is not a Moulin::API" unless api.is_a?(API)
      @api = api
      self.attributes = attrs if attrs
    end

    #def valid?
    #  true
    #end
  
    def attributes=(attrs)
      attrs.each_pair do |attr, value|
        if respond_to?("#{attr}=")
          public_send("#{attr}=", value)
        else
          attributes[attr.to_s] = value
        end
      end
    end
  
    def attributes
      @attributes ||= {}
    end
    
    #def persisted?
    #  id && id != '' && id != 0
    #end
        
    def inspect
      "#<#{self.class} @attributes=#{@attributes.inspect}>"
    end
    
    private
    
    def api
      @api
    end
    
    def read_attribute(attr)
      attributes[attr.to_s]
    end
    
    def write_attribute(attr, value)
      attributes[attr.to_s] = value
    end
  end
end