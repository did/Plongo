module Plongo
  module Elements
    
    class Text < Base

      ## attributes ##
      key :value, String, :required => true
     
      def value=(text)
        text.gsub! /<div(\s+style="[a-zA-Z-;\s:]+")?><br><\/div>/, '<br />'
        text.gsub! /<p(\s+style="[a-zA-Z-;\s:]+")?><br><\/p/, '<br />'
        send(:write_key, :value, text)
      end
     
    end
    
  end  
end