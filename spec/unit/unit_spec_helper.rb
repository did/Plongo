require File.join(File.dirname(__FILE__), '..', 'spec_helper')

MongoMapper.connection = nil

class MyController < ActionController::Base
  
  include Plongo::Rails::BaseController
  
end