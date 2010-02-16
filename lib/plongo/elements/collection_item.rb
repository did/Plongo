module Plongo
  module Elements
    
    class CollectionItem
      include MongoMapper::EmbeddedDocument
      
      plugin Plongo::Plugins::Callbacks
      plugin Plongo::Plugins::Collection
      
      ## attributes ##
      key :_delete, Integer
      key :_position, Integer, :default => 0
      
    end
    
  end  
end