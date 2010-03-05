module Plongo
  
  module Plugins
    
    module Callbacks
      
      def self.configure(model)
        model.class_eval do
          include ActiveSupport::Callbacks

          define_callbacks(
            :after_validation,
            :before_save, :after_save,
            :before_destroy, :after_destroy
          )
        end
      end
      
    end
    
  end
  
end