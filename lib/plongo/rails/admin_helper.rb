module Plongo
  module Rails
    module AdminHelper
    
      def plongo_form(page, url, options = {}, &block)
        form_options = { :method => :put, :multipart => true }.merge(options)
    
        if block_given?
          form_tag(url, form_options, &block)
        else
          form_tag(url, form_options) do
            concat(plongo_fields(page))        
            concat(content_tag(:div, submit_tag('Update'), :class => 'actions'))
          end
        end
      end
  
      def plongo_fields(page)
        content_tag(:fieldset) do      
          page.sorted_elements.inject('') do |html, element|
            html << content_tag(:legend, element.name)
            html << (content_tag(:ol) do
              concat(plongo_field(element))
            end)
          end        
        end
      end  
  
      def plongo_field(element, options = {}, &block)
        type = plongo_type_name((options[:metadata_key] || element)._type)
    
        template = "plongo_#{type}_field".to_sym
    
        if self.respond_to?(template)
          content_tag :li, :class => "plongo-#{type} #{'error' if not element.valid?}" do
            html = block_given? ? block.call : ''
        
            html << content_tag(:label, element.name) if options[:with_label] == true        

            if options[:parent_element]
              options[:class] = 'highlight' if element.key == options[:parent_element].highlight
          
              html << hidden_field_tag(plongo_tag_name('key', element, options), element.key)
            end
                
            html << self.send(template, element, options)        
        
            if not element.valid?
              html << content_tag(:p, element.errors.full_messages.to_sentence, :class => 'inline-errors')
            end
        
            html
          end
        else
          raise "Unknown plongo field tag (#{type})"
        end
      end
 
      def plongo_collection_field(collection, options = {})
        html = ''

        # items
        collection.items.each_with_index do |item, index|        
          html << content_tag(:div, :id => "plongo-item-#{item.id}", :class => 'plongo-item') do
            content_tag(:h3, plongo_item_name(collection, item, index)) + 
            (content_tag(:ol) do 
              item.sorted_elements.inject('') do |memo, nested_element|
                memo << plongo_field(nested_element, { :parent_element => collection, :item => item, :with_label => true })
              end
            end) + 
            link_to('Remove', '#', :class => 'remove-button') +
            hidden_field_tag(plongo_tag_name('_delete', item, { :parent_element => collection }), '') +
            hidden_field_tag(plongo_tag_name('_position', item, { :parent_element => collection }), index, :class => 'position')
          end
        end
      
        # new item
        html << (content_tag(:div, :class => 'plongo-new-item') do
          content_tag(:h3, plongo_item_name(collection)) + (content_tag(:ol) do
            nested_html = ''
            collection.sorted_metadata_keys.each_with_index do |metadata_key, index|
              nested_html << (plongo_field(metadata_key, { :parent_element => collection, :index => index, :with_label => true }) do
                plongo_metadata_key_hidden_fields collection, metadata_key, index
              end)
            end  
            nested_html
          end) + 
          link_to('Remove', '#', :class => 'remove-button') +
          hidden_field_tag(plongo_tag_name('_position', nil, { :parent_element => collection }), 0, :class => 'position')
        end)
      
        html << content_tag(:p, link_to('Add', '#', :class => 'add-button'), :class => 'action')
      end
 
      def plongo_input_field(input, options = {}, &block)    
        text_field_tag(plongo_tag_name('value', input, options), input.value, :class => options[:class])
      end
  
      def plongo_text_field(text, options = {}, &block)
        text_area_tag(plongo_tag_name('value', text, options), text.value)
      end
  
      def plongo_image_field(image, options = {}, &block)
        html = ''
  
        html << (content_tag(:div, :class => 'preview') do
          nested_html = link_to(image_tag(image.source.url(:thumbnail)), image.source.url)
          nested_html << content_tag(:p, image.source_file_name)          
        end) if image.source?
            
        html << file_field_tag(plongo_tag_name('source', image, options))
      
        html << '<div class="clear">&nbsp;</div>'
      end
    
      def plongo_type_name(klass)
        (klass.is_a?(String) ? klass : klass.name).demodulize.downcase
      end
  
      def plongo_metadata_key_hidden_fields(element, metadata_key, index)
        %w{_type key name priority}.inject('') do |html, name|
          tag_name = plongo_tag_name(name.gsub(/^_/, ''), element, { :index => index })
          html << hidden_field_tag(tag_name, metadata_key.send(name.to_sym))
        end
      end
  
      def plongo_tag_name(name, element, options = {})
        parent_element = options[:parent_element] || element
    
        with_metadata_key = !options[:index].nil?
        top_level_element = options[:item].nil? && !with_metadata_key && parent_element == element
        
        common_part = "page[element_attributes][#{parent_element.id}]"
    
        if top_level_element
          "#{common_part}[#{name}]"
        elsif with_metadata_key
          "#{common_part}[item_attributes][NEW_RECORD_0][element_attributes][#{options[:index]}][#{name}]"
        elsif options[:item].nil?
          "#{common_part}[item_attributes][#{element ? element.id : 'NEW_RECORD_0'}][#{name}]"
        else
          "#{common_part}[item_attributes][#{options[:item].id}][element_attributes][#{element.id}][#{name}]"
        end
      end
  
      def plongo_item_name(collection, item = nil, index = nil)
        if collection.highlight.nil?
          index ? "Item ##{index + 1}" : "New Item"
        else
          if item 
            item.find_element_by_key(collection.highlight).value
          else
            collection.find_metadata_key_by_key(collection.highlight).value
          end
        end
      end
    end
  end
end