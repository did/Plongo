module Plongo
  
  class Page
    
    include MongoMapper::Document
    
    ## attributes ##
    key :name, String, :required => true
    key :uri, String
    key :path, String, :required => true
    key :shared, Boolean, :default => false
    # key :template, Array
    
    plugin Plongo::Plugins::Collection
     
  end
  
end