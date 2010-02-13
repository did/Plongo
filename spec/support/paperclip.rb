# Temporary path to put downloaded files
Paperclip::Attachment.default_options.merge!({
  :path => ":test/:attachment/:id/:style/:basename.:extension"
})

Paperclip.options[:log] = false

module FixturedAsset
  def self.open(filename)
    File.new(self.path(filename))
  end
  
  def self.path(filename)
    File.join(File.dirname(__FILE__), '..', 'fixtures', 'assets', filename)
  end
  
  def self.duplicate(filename)
    dst = File.join(File.dirname(__FILE__), '..', 'tmp', filename)
    FileUtils.cp self.path(filename), dst
    dst
  end
end

Paperclip.interpolates :test do |attachment, style|
  TEST_DIR
end