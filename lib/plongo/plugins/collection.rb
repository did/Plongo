module Plongo
  
  module Plugins
  
    module Collection
    
      def self.configure(model)
        model.class_eval do
          ## associations ##
          many :elements, :class_name => 'Plongo::Elements::Base', :polymorphic => true

          ## callbacks ##
          before_save :before_save_elements
          after_save :after_save_elements
          before_destroy :before_destroy_elements
          after_destroy :after_destroy_elements

          ## validations ##
          validates_associated :elements
        end
      end
    
      module InstanceMethods

        def sorted_elements
          self.elements.sort { |a, b| (a.priority || 99) <=> (b.priority || 99) }
        end

        def find_element_by_key(key)
          self.elements.detect { |el| el.key == key }
        end

        def element_attributes=(hash = {})
          # based on accepts_nested_attributes_for but in our case just handle updates
          hash.each_pair do |id, attributes|
            attributes.symbolize_keys!
            
            if (element = self.elements.detect { |el| el._id.to_s == id.to_s })
              element.attributes = attributes.symbolize_keys
            else
              if attributes.key?(:type)
                element = attributes[:type].constantize.new(attributes)
              else
                element = build_element_from_metadata(attributes) # type not present, should be a collection item
              end
              self.elements << element
            end
          end
        end

        protected

        def before_save_elements
          self.elements.each { |el| el.send(:run_callbacks, :before_save) }
        end

        def after_save_elements
          self.elements.each { |el| el.send(:run_callbacks, :after_save) }
        end

        def before_destroy_elements
          self.elements.each { |el| el.send(:run_callbacks, :before_destroy) }
        end

        def after_destroy_elements
          self.elements.each { |el| el.send(:run_callbacks, :after_destroy) }
        end
    
      end
      
    end
    
  end
  
end