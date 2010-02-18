$:.unshift "#{File.dirname(__FILE__)}/lib"

require 'plongo'

ActionController::Base.send :include, Plongo::Rails::BaseController
ActionView::Base.send :include, Plongo::Rails::BaseViewHelper
ActionView::Base.send :include, Plongo::Rails::ContentTagHelper
ActionView::Base.send :include, Plongo::Rails::ImageTagHelper
ActionView::Base.send :include, Plongo::Rails::CustomTagHelper