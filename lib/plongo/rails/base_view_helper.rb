module Plongo
  module Rails
   
    module BaseViewHelper
   
      protected

      def add_plongo_element(tag, key, options = {}, &block)
        if defined?(@plongo_collection) && !@plongo_collection.nil?
          element = name_to_plongo_element_klass(tag, &block).new(options.merge(:key => key))
          @plongo_collection.metadata_keys << element
          
          plongo_page.save
          
          element
        else
          puts "block_given? #{block_given?} / #{key} / #{plongo_container.inspect} / #{options.inspect}"
          if (element = plongo_container.find_element_by_key(key)).nil?
            element = name_to_plongo_element_klass(tag, &block).new(options.merge(:key => key))
            plongo_container.elements << element
          else            
            options.delete(:value)
            element.attributes = options
            
            puts "___ found it #{element.inspect}" 
          end
        
          plongo_page.save
        
          element
        end
      end
   
      # def add_plongo_element(tag, key, options = {}, &block)
      #   if (element = plongo_page.find_element_by_key(key)).nil?
      #     element = name_to_plongo_element_klass(tag, &block).new(options.merge(:key => key))
      #     plongo_page.elements << element          
      #   else
      #     options.delete(:value)
      #     element.attributes = options
      #   end
      #   
      #   plongo_page.save
      #   
      #   element
      # end
      
      def plongo_container
        return @plongo_item if defined?(@plongo_item) && !@plongo_item.nil?        
        plongo_page
      end
   
      def plongo_page
        return @plongo_page if defined?(@plongo_page) && !@plongo_page.nil?
        
        path = File.join(@controller.controller_path, @controller.action_name)
        @plongo_page = Plongo::Page.find_by_path(path) || Plongo::Page.create(:name => @controller.action_name, :path => path)
      end
      
      def name_to_plongo_element_klass(name, &block)
        case name.to_s
        when /h[1-9]/, 'b', 'i', 'u', 'span', 'a', 'em', 'small', 'strong' then Plongo::Elements::Input
        when 'img' then Plongo::Elements::Image
        when 'div', 'ol', 'ul', 'dl', 'table', 'tbody'
          if block_given? #&& block.arity == 1
            Plongo::Elements::Collection
          else
            Plongo::Elements::Text
          end
        else
          Plongo::Elements::Text
        end
      end
   
    end
    
  end
end