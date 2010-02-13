module Plongo
  module Support
    module Callbacks
      def self.configure(model)
        model.class_eval do
          include ActiveSupport::Callbacks

          define_callbacks(
            :before_save, :after_save,
            :before_destroy, :after_destroy
          )
        end
      end
    end
  end
end
    # module InstanceMethods
    #       def valid?
    #         action = new? ? 'create' : 'update'
    # 
    #         run_callbacks(:before_validation)
    #         run_callbacks("before_validation_on_#{action}".to_sym)
    #         result = super
    #         run_callbacks("after_validation_on_#{action}".to_sym)
    #         run_callbacks(:after_validation)
    # 
    #         result
    #       end
    # 
    #       def destroy
    #         run_callbacks(:before_destroy)
    #         result = super
    #         run_callbacks(:after_destroy)
    #         result
    #       end
    # 
    #       private
    #       
    #         def 
    #       
    #         def create_or_update(*args)
    #           run_callbacks(:before_save)
    #           if result = super
    #             run_callbacks(:after_save)
    #           end
    #           result
    #         end
    # 
    #         def create(*args)
    #           run_callbacks(:before_create)
    #           result = super
    #           run_callbacks(:after_create)
    #           result
    #         end
    # 
    #         def update(*args)
    #           run_callbacks(:before_update)
    #           result = super
    #           run_callbacks(:after_update)
    #           result
    #         end
    # end
#   end
# end