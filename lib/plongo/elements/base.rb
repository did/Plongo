module Plongo
  module Elements
    
    class Base
          
      include MongoMapper::EmbeddedDocument
      
      plugin Plongo::Plugins::Callbacks
      
      ## attributes ##
      key :key, String, :required => true
      key :priority, Integer
      key :_type, String
   
      ## methods ##
      
      protected
      
      def logger
        RAILS_DEFAULT_LOGGER
      end
      
    end
    
  end  
end