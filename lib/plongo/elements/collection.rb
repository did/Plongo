module Plongo
  module Elements
    
    class Collection < Base

      ## associations ##
      many :metadata_keys, :class_name => 'Plongo::Elements::Base', :polymorphic => true
      many :items, :class_name => 'Plongo::Elements::CollectionItem'
          
      def item_attributes=(hash = {})
        # based on accepts_nested_attributes_for but in our case just handle updates
        hash.each_pair do |id, attributes|
          attributes.symbolize_keys!
          
          if (item = self.items.detect { |item| item._id.to_s == id.to_s })
            item.attributes = attributes.symbolize_keys
          else
            self.items << Plongo::Elements::CollectionItem.new(attributes)
          end
        end
      end
      
      def sorted_metadata_keys
        self.metadata_keys.sort { |a, b| (a.priority || 99) <=> (b.priority || 99) }
      end    
      
    end
    
  end  
end