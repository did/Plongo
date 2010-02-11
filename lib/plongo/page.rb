module Plongo
  
  class Page
    
    include MongoMapper::Document
    
    ## attributes ##
    key :name, :required => true
    key :path, :required => true
    key :template, Array

    ## associations ##
    many :elements, :class_name => 'Plongo::Elements::Base', :polymorphic => true
    
    ## methods ##
    
    def sorted_elements
      self.elements.sort { |a, b| (a.priority || 99) <=> (b.priority || 99) }
    end
    
    def find_element_by_key(key)
      self.elements.detect { |el| el.key == key }
    end
    
    def element_attributes=(data = [])
      # puts "data = #{data.inspect}"
      # based on accepts_nested_attributes_for but in our case just handle updates
      data.each do |attributes|
        attributes.symbolize_keys!
        # puts "attributes = #{attributes.inspect} / #{attributes.symbolize_keys!.inspect} / #{attributes[:id]} / #{attributes['id']}"
        
        if (element = self.elements.detect { |el| el._id.to_s == attributes[:id].to_s })
          # puts "el = #{element.inspect}"
          attributes.delete(:id)
          element.attributes = attributes
        end
      end
    end
    
  end
  
end