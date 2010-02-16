module Plongo
  module Rails
   
    module BaseController
   
      def self.included(base)
        base.send :alias_method_chain, :render, :plongo
      end
     
      protected
     
      def render_with_plongo(options = nil, extra_options = {}, &block)
        output = render_without_plongo(options, extra_options, &block)
        
        if defined?(@plongo_pages)
          @plongo_pages.collect(&:save)
        end
        
        output
      end
      
      def append_plongo_page(page)
        ((@plongo_pages ||= []) << page).uniq!
      end
      
    end
  
  end
  
end