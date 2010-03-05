module Plongo
  module Elements
    
    class CollectionItem
      include MongoMapper::EmbeddedDocument
      
      plugin Plongo::Plugins::Callbacks
      plugin Plongo::Plugins::Collection
      
      ## attributes ##
      key :_delete, Integer
      key :_position, Integer, :default => 0
      
      def build_element_from_metadata(attributes)
        metadata_key = self._parent_document.find_metadata_key_by_key(attributes[:key])        
        
        element = metadata_key._type.constantize.new(metadata_key.attributes.delete_if { |k, v| %w{_id keys}.include?(k) })
        
        element.attributes = attributes 

        element
      end
      
    end
    
  end  
end