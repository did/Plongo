module Plongo
  module Elements
    
    class Collection < Base

      ## associations ##
      many :metadata_keys, :class_name => 'Plongo::Elements::Base', :polymorphic => true
      many :items, :class_name => 'Plongo::Elements::CollectionItem'
      
      ## attributes
      key :highlight
      
      ## callbacks ##
      before_save :sort_items
      before_save :delete_items
      
      before_save :before_save_items
      after_save :after_save_items
      before_destroy :before_destroy_items
      after_destroy :after_destroy_items
      
      ## validations ##
      validates_associated :items
          
      def item_attributes=(hash = {})
        # based on accepts_nested_attributes_for but in our case just handle updates
        hash.each_pair do |id, attributes|
          attributes.symbolize_keys!
          
          if (item = self.items.detect { |item| item._id.to_s == id.to_s })
            item.attributes = attributes.symbolize_keys
          else
            item = self.items.build
            item.attributes = attributes
          end
        end
      end
            
      def sorted_metadata_keys
        self.metadata_keys.sort { |a, b| (a.priority || 99) <=> (b.priority || 99) }
      end
      
      def find_metadata_key_by_key(key)
        self.metadata_keys.detect { |el| el.key == key }
      end
      
      protected
      
      def sort_items
        self.items.sort! { |a, b| a._position <=> b._position }
      end
      
      def delete_items
        self.items.delete_if { |item| item._delete == true || item._delete == '1' || item._delete == 1 }
      end
      
      def before_save_items
        self.items.each { |el| el.send(:run_callbacks, :before_save) }
      end

      def after_save_items
        self.items.each { |el| el.send(:run_callbacks, :after_save) }
      end

      def before_destroy_items
        self.items.each { |el| el.send(:run_callbacks, :before_destroy) }
      end

      def after_destroy_items
        self.items.each { |el| el.send(:run_callbacks, :after_destroy) }
      end
      
    end
    
  end  
end