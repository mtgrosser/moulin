module Moulin
  module Operations
    
    module Update
      def update(attrs = nil)
        self.attributes = attrs if attrs
        api.update(self)
      end
    end

    module Destroy
      def destroy
        api.destroy(self)
      end
    end
    
  end
end
