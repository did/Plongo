module Plongo
  
  module Plugins
  
    module Paperclip
    
      def self.configure(model)
        model.class_eval do
          include ::Paperclip
          
          class << self
            def has_attached_file(name, options = {})
              has_attached_file_with_mongomapper(name, options)
            end
          end
        end
      end

      module ClassMethods
        
        def has_attached_file_with_mongomapper(name, options = {})
          include ::Paperclip::InstanceMethods

          write_inheritable_attribute(:attachment_definitions, {}) if attachment_definitions.nil?
          attachment_definitions[name] = {:validations => []}.merge(options)

          after_save :save_attached_files
          before_destroy :destroy_attached_files

          define_callbacks :before_post_process, :after_post_process
          define_callbacks :"before_#{name}_post_process", :"after_#{name}_post_process"

          define_method name do |*args|
            a = attachment_for(name)
            (args.length > 0) ? a.to_s(args.first) : a
          end

          define_method "#{name}=" do |file|
            attachment_for(name).assign(file)
          end

          define_method "#{name}?" do
            attachment_for(name).file?
          end

          validates_each name, :logic => lambda {
            attachment = attachment_for(name)
            attachment.send(:flush_errors) unless attachment.valid?
          }
        end
        
      end
    
      module InstanceMethods
    
      end
      
    end
    
  end
  
end

module Paperclip 
  class Cropper < Thumbnail
  
    def initialize file, options = {}, attachment = nil
      if options[:geometry] == "100%x100%" && attachment.instance.cropped?
        options[:geometry] = "#{attachment.instance.width}x#{attachment.instance.height}#"
      end
      super
    end
    
  end
end

Paperclip.interpolates :id_partition do |attachment, style|
  if (id = attachment.instance.id).is_a?(Integer)
    ("%09d" % id).scan(/\d{3}/).join("/")
  else
    id.scan(/.{3}/).first(3).join("/")
  end
end