module Plongo
  module Rails
   
    module BaseController
   
      def self.included(base)
        base.send :alias_method_chain, :render, :plongo
      end
     
      protected
     
      def render_with_plongo(options = nil, extra_options = {}, &block)
        output = render_without_plongo(options, extra_options, &block)
                
        self.save_plongo_pages
        
        output
      end
      
      def save_plongo_pages
        if defined?(@plongo_pages)
          @plongo_pages.collect(&:save)
        end
      end
      
      def append_plongo_page(page)
        @plongo_pages ||= []
        if existing_page = @plongo_pages.find { |p| p.path == page.path }
          existing_page.attributes = page.attributes
        else
          @plongo_pages << page
        end
      end
      
    end
  
  end
  
end