$:.unshift File.expand_path(File.dirname(__FILE__))

require 'plongo/support/paperclip'
require 'plongo/support/callbacks'
require 'plongo/page'
require 'plongo/elements/base'
require 'plongo/elements/input'
require 'plongo/elements/text'
require 'plongo/elements/image'
require 'plongo/rails/base_view_helper'
require 'plongo/rails/content_tag_helper'
require 'plongo/rails/image_tag_helper'