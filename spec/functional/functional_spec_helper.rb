require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require 'rubygems'
 
def smart_require(lib_name, gem_name, gem_version = '>= 0.0.0')
  begin
    require lib_name if lib_name
  rescue LoadError
    if gem_name
      gem gem_name, gem_version
      require lib_name if lib_name
    end
  end
end

smart_require 'active_support', 'activesupport', '>= 2.3.4'
smart_require 'action_controller', 'actionpack', '>= 2.3.4'
smart_require 'action_view', 'actionpack', '>= 2.3.4'

# begin
#   require File.dirname(__FILE__) + '/../../../../../spec/spec_helper'
# rescue LoadError => e
#   puts "******** You need to install rspec in your base app *******"
#   puts e.message
#   raise
# end

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, {
  :logger => Logger.new(TEST_DIR + '/test.log')
})
MongoMapper.database = 'plongotest'

MongoMapper.database.collection_names.each do |collection|
  next if collection == 'system.indexes'
  MongoMapper.database.collection(collection).drop
end

