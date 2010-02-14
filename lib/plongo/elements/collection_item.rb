module Plongo
  module Elements
    
    class CollectionItem
      include MongoMapper::EmbeddedDocument
      
      plugin Plongo::Plugins::Callbacks
      plugin Plongo::Plugins::Collection
      
    end
    
  end  
end