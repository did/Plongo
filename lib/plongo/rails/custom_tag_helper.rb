module Plongo
  module Rails
   
    module CustomTagHelper
      
      def plongo_content(key, type, options = {}, &block)
        options[:name] = key if options[:name].blank?
        
        element = add_plongo_element(type, key, options, &block)
        
        if element.respond_to?(:source)
          element.source? ? element.url : element.value 
        elsif element.respond_to?(:items)
          element.items
        else
          element.value
        end
      end
            
    end
    
  end
end
