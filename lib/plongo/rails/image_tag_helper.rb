module Plongo
  module Rails
   
    module ImageTagHelper
   
      def self.included(base)
        base.send :alias_method_chain, :image_tag, :plongo
      end
     
      def image_tag_with_plongo(source, options = {})
        if !options[:plongo_key].blank? || !options[:plongo].blank?
          plongo_options = options.delete(:plongo) || {}
          
          key = options.delete(:plongo_key) || plongo_options[:key]
          
          if size = options[:size]
            plongo_options[:width], plongo_options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
          end
          
          # puts "key = #{key}"
        
          element = add_plongo_element(:img, key, {
            :value => source,
            :name => options[:alt] || 'Image',
            
          }.merge(plongo_options))
          
          # puts "*** source = #{element.source.url.inspect} / #{element.source?} / #{element.value}"          
          
          source = element.source? ? element.url : source
        end
        
        image_tag_without_plongo(source, options)
      end
      
    end
  end
end