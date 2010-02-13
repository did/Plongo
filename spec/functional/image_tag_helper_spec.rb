require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

include ActionView::Helpers

describe 'ImageTagHelper' do
  
  include Plongo::Rails::BaseViewHelper
  include Plongo::Rails::ImageTagHelper
  
  attr_accessor :output_buffer
  
  before(:each) do
    @output_buffer = ''
    @controller = mock('FakeController')
    @controller.stubs(:controller_path).returns('pages')
    @controller.stubs(:action_name).returns('home')
    Plongo::Page.destroy_all
  end    
  
  it 'should render image tag without plongo' do
    image_tag('http://www.somewhere.net', :alt => 'nice').should == '<img alt="nice" src="http://www.somewhere.net" />'
  end
  
  it 'should store a new element for the current page if passing the right option' do
    lambda {
      image_tag('banner.png', :alt => 'Banner', :plongo_key => 'banner').should == '<img alt="Banner" src="/images/banner.png" />'
    }.should change(Plongo::Page, :count).by(1)
    
    page = Plongo::Page.all.last
  
    page.elements.should_not be_empty
    page.elements[0].class.should == Plongo::Elements::Image
    page.elements[0].name.should == 'Banner'
  end  
  
  it 'should accept options' do
    image_tag('banner.png', :plongo => { :key => 'banner', :priority => 42, :name => 'Test' }).should == '<img alt="Banner" src="/images/banner.png" />'
    
    page = Plongo::Page.all.last
    page.elements.first.name.should == 'Test'
    page.elements.first.priority.should == 42
  end
  
  it 'should use an uploaded image' do
    image_tag_with_an_uploaded_file('banner.png', 'picture.png', { :alt => 'Banner', :plongo_key => 'banner' })

    output = image_tag('banner.png', :alt => 'Banner', :plongo_key => 'banner')
    output.should match(/\/system\/sources\/[a-zA-F0-9]+\/original\/picture.png/)
  end
  
  it 'should crop an uploaded image' do
    options = { :alt => 'Banner', :plongo_key => 'banner', :size => '48x32' }
    image = image_tag_with_an_uploaded_file('banner.png', 'big.jpg', options.dup)
    
    output = image_tag('banner.png', options)
    output.should match(/\/system\/sources\/[a-zA-F0-9]+\/cropped\/big.png/)
    output.should match(/width=\"48\"/)
    output.should match(/height=\"32\"/)
  end
  
  protected
  
  def image_tag_with_an_uploaded_file(name, filename, options = {})
    image_tag('banner.png', options)
    
    page = Plongo::Page.find_by_path('pages/home')
    element = page.elements[0]
    element.source = FixturedAsset.open(filename)
    page.save!
    
    @plongo_page = nil # reload
  end
  
end