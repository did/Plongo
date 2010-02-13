module Plongo
  module Rails
   
    module BaseViewHelper
   
      protected
   
      def add_plongo_element(tag, key, options = {})
        if (element = plongo_page.find_element_by_key(key)).nil?
          element = name_to_plongo_element_klass(tag).new(options.merge(:key => key))
          plongo_page.elements << element          
        else
          options.delete(:value)
          element.attributes = options
        end
        
        plongo_page.save
        
        element
      end
   
      def plongo_page
        return @plongo_page if defined?(@plongo_page) && !@plongo_page.nil?
        
        path = File.join(@controller.controller_path, @controller.action_name)
        @plongo_page = Plongo::Page.find_by_path(path) || Plongo::Page.create(:name => @controller.action_name, :path => path)
      end
      
      def name_to_plongo_element_klass(name)
        case name.to_s
        when /h[1-9]/, 'b', 'i', 'u', 'span', 'a', 'em', 'small', 'strong' then Plongo::Elements::Input
        when 'img' then Plongo::Elements::Image
        else
          Plongo::Elements::Text
        end
      end
   
    end
    
  end
end