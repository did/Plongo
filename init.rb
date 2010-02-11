$:.unshift "#{File.dirname(__FILE__)}/lib"

require 'plongo'

ActionView::Base.send :include, Plongo::Rails::ContentTagHelper