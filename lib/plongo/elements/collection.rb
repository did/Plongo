module Plongo
  module Elements
    
    class Collection < Base

      ## associations ##
      many :metadata_keys, :class_name => 'Plongo::Elements::Base', :polymorphic => true
      many :items, :class_name => 'Plongo::Elements::CollectionItem'
          
      def item_attributes=(data = [])
        # based on accepts_nested_attributes_for but in our case just handle updates
        data.each do |attributes|
          attributes.symbolize_keys!

          if (item = self.items.detect { |item| item._id.to_s == attributes[:id].to_s })
            attributes.delete(:id)
            item.attributes = attributes
          end
        end
      end
      
      # def add_metadata_keys(metadata_key)
      #   if (key = self.metadata_keys.detect { |el| el.key == metadata_key.key }).nil?
      #     self.metadata_keys << metadata_key
      #   else
      #     key.attributes
      #   end
      # end
      
      def sorted_metadata_keys
        self.metadata_keys.sort { |a, b| (a.priority || 99) <=> (b.priority || 99) }
      end    
    end
    
  end  
end