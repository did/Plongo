$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'mocha'
require 'mongo_mapper'

# require 'carrierwave'
require 'paperclip'
require 'support/paperclip'
require 'plongo'
require 'spec'
require 'spec/autorun'
require 'action_controller'

TEST_DIR = File.expand_path(File.dirname(__FILE__) + '/../tmp')

FileUtils.rm_rf(TEST_DIR)
FileUtils.mkdir_p(TEST_DIR)

RAILS_DEFAULT_LOGGER = Logger.new(File.join(TEST_DIR, 'paperclip.log'))

# I18n.load_path << Dir[File.join(File.dirname(__FILE__), '..', 'config', 'locales', '*.{rb,yml}') ] 
# I18n.default_locale = :en

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

I18n.locale = 'en'