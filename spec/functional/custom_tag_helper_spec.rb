require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

include ActionView::Helpers

describe 'CustomTagHelper' do
  
  include Plongo::Rails::BaseViewHelper
  include Plongo::Rails::CustomTagHelper
  
  attr_accessor :output_buffer
  
  before(:each) do
    @output_buffer = ''
    @request = mock('FakeRequest')
    @request.stubs(:request_uri).returns('/')
    @controller = FakeController.new(@request)
    Plongo::Page.destroy_all
  end    
  
  it 'should store a new element for the current page if passing the right option' do
    lambda {
      plongo_content('title', :input, { :value => 'Hello world' }).should == 'Hello world'
      @controller.send(:save_plongo_pages) # uber important
    }.should change(Plongo::Page, :count).by(1)
    
    page = Plongo::Page.all.last
  
    page.elements.should_not be_empty
    page.elements[0].class.should == Plongo::Elements::Input
    page.elements[0].key.should == 'title'
    page.elements[0].name.should == 'title'
  end
  
  it 'should handle image type' do
    plongo_content('banner', :image, { :value => 'banner.jpg', :width => 200, :height => 100 }).should == 'banner.jpg'
    
    @controller.send(:save_plongo_pages) # uber important
    
    page = Plongo::Page.all.last
    element = page.elements[0]
    element.width.should == 200
    element.height.should == 100
    element.source = FixturedAsset.open('picture.png')
    page.save!
    
    @plongo_page = nil # reload
    
    output = plongo_content('banner', :image, { :value => 'banner.jpg' })
    output.should match(/\/system\/sources\/[a-zA-F0-9]+\/cropped\/picture.png/)
  end
  
end