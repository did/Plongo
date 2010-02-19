module Plongo
  module Rails
   
    module ContentTagHelper
   
      def self.included(base)
        base.send :alias_method_chain, :content_tag, :plongo
      end
     
      def content_tag_with_plongo(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
        if block_given?
          options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
          
          if options.is_a?(Hash) && (!options.symbolize_keys[:plongo_key].blank? || !options.symbolize_keys[:plongo].blank?)          
            plongo_options = options.delete(:plongo) || {}
            key = options.delete(:plongo_key) || plongo_options[:key]

            element = add_plongo_element(name, key, {
              :value => content_or_options_with_block, 
              :name => key.humanize
            }.merge(plongo_options), &block)
            
            if element.respond_to?(:metadata_keys)
              # puts "collection found !!!"
              # dealing with collection type
              
              if element.items.empty?
                # puts "initializing collection.....#{element.inspect}"
                # element.metadata_keys = []
                @plongo_collection = element
                
                output = content_tag_without_plongo(name, options, nil, escape, &block)
                
                @plongo_collection = nil
                
                plongo_page.save! # saving page at this time is required if the collection is used further
                
                # puts "collection saved !"
                
                output
              else
                # puts "================================================================="
                output = element.items.inject('') do |output, item|
                  # puts "render item #{item.inspect}"
                  @plongo_item = item
        
                  # puts "---->" + (foo = capture(&block))
                  # puts "-------------------------------"
                  output + capture(&block)
                end
                
                output = content_tag_string(name, output, options, escape)
                
                @plongo_item = nil # reset it
                
                # if block_called_from_erb?(block)
                #   concat(output)
                # else
                #   output
                # end
                # puts "[OUTPUT] #{name} / #{output} / #{options}"
                # content_tag_without_plongo(name, output, options, escape)
                
                if block_called_from_erb?(block)
                  concat(output)
                else
                  output
                end
              end        
            else
              content_tag_without_plongo(name, element.value, options, escape)
              # content_tag_string(name, element.value, options, escape)
              # DONE
            end
          else
            # DONE
            content_tag_without_plongo(name, options, nil, escape, &block)
          end
        else
          # DONE
          if options.is_a?(Hash) && (!options.symbolize_keys[:plongo_key].blank? || !options.symbolize_keys[:plongo].blank?)          
            plongo_options = options.delete(:plongo) || {}
            key = options.delete(:plongo_key) || plongo_options[:key]

            element = add_plongo_element(name, key, {
              :value => content_or_options_with_block, 
              :name => key.humanize
            }.merge(plongo_options), &block)
            
            # puts "!!! writing #{element.value} !!!"

            # content_tag_without_plongo(name, element.value, options, escape)
            content_or_options_with_block = element.value
          end
          
          content_tag_without_plongo(name, content_or_options_with_block, options, escape)
        end
      end
            
    end
    
    # class CollectionItemProxy
    #   
    #   def initialize(collection)
    #     puts "creating collection !"
    #     @collection = collection
    #   end
    #   
    #   # def method_missing(name, *args)
    #   #   puts "calling #{name}"
    #   # end
    #   
    #   def content_tag(*args)
    #     puts "calling #{@collection.name}"
    #   end
    #   
    #   def foo
    #     puts "hello world !!!"
    #   end
    #   
    #   def to_s
    #     "CollectionItemProxy ready (#{@collection.name}) !"
    #   end
    #   
    # end
    
  end
end


# if block_given? && block.arity == 1
#   logger.debug "===> Collection found !!!!"
# end




# content_tag_without_plongo(name, content_or_options_with_block, options, escape, &block)


# if element.elements.empty?
#   content_tag_string(name, "Collection empty", options, escape)
# else
#   output = element.items('').inject do |output, item| 
#     output + content_tag_string(name, capture(Plongo::Rails::CollectionItemProxy.new(item), &block), options, escape)
#   end
#   
#   if block_called_from_erb?(block)
#     concat(output)
#   else
#     output
#   end
# end