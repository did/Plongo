module Plongo
  module Elements
    
    class Base
     
      include MongoMapper::EmbeddedDocument
      
      ## attributes ##
      key :key, String, :required => true
      key :priority, Integer
      key :_type, String
      
    end
    
  end  
end