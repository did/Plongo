require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'Image' do
  
  it 'should be valid' do
    Plongo::Elements::Image.new(image_attributes).should be_valid
  end
  
  it 'should have an attachment' do
    image = Plongo::Elements::Image.new(image_attributes(:source => FixturedAsset.open('picture.png')))
    image.should be_valid
    image.source.should_not be_nil
  end
  
  it 'should not be valid if attachment is not an image' do
    image = Plongo::Elements::Image.new(image_attributes(:source => FixturedAsset.open('wrong.txt')))
    image.should_not be_valid
  end
  
  it 'should be cropped' do
    image = Plongo::Elements::Image.new
    image.cropped?.should be_false
    
    image.width = 200
    image.height = 100
    
    image.cropped?.should be_true
    image.size.should == '200x100'
  end
  
  protected
  
  def image_attributes(options = {})
    {
      :key => 'banner', 
      :name => 'A banner', 
      :priority => 1
    }.merge(options)
  end
  
end