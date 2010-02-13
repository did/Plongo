module Plongo
  module Rails
   
    module ContentTagHelper
   
      def self.included(base)
        base.send :alias_method_chain, :content_tag, :plongo
      end
     
      def content_tag_with_plongo(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
        if options.is_a?(Hash) && (!options.symbolize_keys[:plongo_key].blank? || !options.symbolize_keys[:plongo].blank?)
          options.symbolize_keys! # FIXME: not sure it's required
          
          # path = File.join(@controller.controller_path, @controller.action_name)
          # page = Plongo::Page.find_by_path(path) || Plongo::Page.create(:name => @controller.action_name, :path => path)
          # 
          # puts "page = #{page.inspect} / #{options.inspect}"
          
          plongo_options = options.delete(:plongo) || {}
          key = options.delete(:plongo_key) || plongo_options[:key]
          
          element = add_plongo_element(name, key, {
            :value => content_or_options_with_block, 
            :name => content_or_options_with_block
          }.merge(plongo_options))
          
          # if (element = plongo_page.find_element_by_key(key)).nil?
          #   # puts "create new element ! - #{plongo_options.inspect}"
          #   plongo_options.merge!(:key => key, :value => content_or_options_with_block, :name => content_or_options_with_block)
          #   element = name_to_plongo_element_klass(name).new(plongo_options)
          #   plongo_page.elements << element
          #   plongo_page.save
          # end
          
          content_or_options_with_block = element.value
          # puts "element value = #{element.value} /"
        end
        
        content_tag_without_plongo(name, content_or_options_with_block, options, escape, &block)
      end
            
    end
    
  end
end