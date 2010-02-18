module Plongo
  module Rails
   
    module BaseViewHelper
   
      protected

      def add_plongo_element(tag_or_type, key, options = {}, &block)
        if defined?(@plongo_collection) && !@plongo_collection.nil?          
          if (element = @plongo_collection.find_metadata_key_by_key(key)).nil?
            element = name_to_plongo_element_klass(tag_or_type, &block).new(options.merge(:key => key))
            @plongo_collection.metadata_keys << element
          else
            element.attributes = options
          end
          
          puts "adding #{element.inspect} / #{@plongo_collection.metadata_keys.size}"
          
          element
        else
          # puts "block_given? #{block_given?} / #{key} / #{plongo_container.inspect} / #{options.inspect}"
          container = plongo_container(options[:page])
          
          if (element = container.find_element_by_key(key)).nil?
            element = name_to_plongo_element_klass(tag_or_type, &block).new(options.merge(:key => key))
            container.elements << element
          else            
            options.delete(:value)
            element.attributes = options
          end
        
          element
        end
      end
         
      def plongo_container(options = nil)
        return @plongo_item if defined?(@plongo_item) && @plongo_item
        plongo_page(options)
      end
   
      def plongo_page(options = nil)
        return @plongo_page if (options.nil? || options.empty?) && defined?(@plongo_page) && @plongo_page
        
        current_path = File.join(@controller.controller_path, @controller.action_name) 
        
        page_options = { 
          :name => @controller.action_name,
          :uri  => @controller.request.request_uri,
          :path => current_path,
          :shared => false
        }.merge(options || {})
        
        page_options[:shared] = true if options && !options[:path].blank? && options[:path] != current_path
        
        page = Plongo::Page.find_by_path(page_options[:path]) || Plongo::Page.create(page_options)
        
        @controller.send(:append_plongo_page, page)
        
        @plongo_page = page if (options.nil? || options.empty?)
        
        page
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
          begin
            "Plongo::Elements::#{name.to_s.capitalize}".constantize
          rescue NameError
            Plongo::Elements::Text
          end
        end
      end
   
    end
    
  end
end