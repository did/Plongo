module Plongo
  module Elements
    
    class Image < Base

      ## behaviours ##
      has_attached_file :source, :styles => { 
          :thumbnail => ["50x50#", :png], 
          :cropped => ["100%x100%", :png] 
        }, 
        :processors => [:cropper]
      
      ## attributes ##
      key :width, Integer
      key :height, Integer
      key :source_file_name, String
      key :source_content_type, String
      key :source_file_size, Integer
      key :source_updated_at, Time

      ## validations ##
      validates_attachment_content_type :source, :content_type => %r{image/}
      
      ## methods ##
      
      def cropped?
        !(self.width.blank? || self.height.blank?)
      end
      
      def size
        "#{self.width}x#{self.height}" if self.width && self.height
      end
      
      def url
        self.cropped? ? self.source.url(:cropped) : self.source.url
      end
    end
    
  end  
end