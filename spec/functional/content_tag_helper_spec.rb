require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

include ActionView::Helpers

describe 'ContentTagHelper' do
  
  include Plongo::Rails::BaseViewHelper
  include Plongo::Rails::ContentTagHelper
  
  attr_accessor :output_buffer
  
  before(:each) do
    @output_buffer = ''
    @controller = mock('FakeController')
    @controller.stubs(:controller_path).returns('pages')
    @controller.stubs(:action_name).returns('home')
    Plongo::Page.destroy_all
  end    
  
  it 'should render tags without plongo' do
    content_tag(:h1, 'Hello world').should == '<h1>Hello world</h1>'
    content_tag(:p) do
      concat('Lorem ipsum')
    end.should == '<p>Lorem ipsum</p>'
  end
  
  it 'should store a new element for the current page if passing the right option' do
    lambda {
      content_tag(:h1, 'Title goes here', :plongo_key => 'title').should == '<h1>Title goes here</h1>'
    }.should change(Plongo::Page, :count).by(1)
    
    lambda {
      content_tag(:h1, 'It does not matter', :plongo_key => 'title').should == '<h1>Title goes here</h1>'
    }.should_not change(Plongo::Page, :count).by(1)

    page = Plongo::Page.all.last

    page.name.should == 'home'    
    page.path.should == 'pages/home'
  end
  
  it 'should accept options' do
    content_tag(:h1, 'Title goes here', :plongo => { :key => 'title', :priority => 42 }).should == '<h1>Title goes here</h1>'
    
    page = Plongo::Page.all.last
    page.elements.size.should == 1
    page.elements.first.name.should == 'Title goes here'
    page.elements.first.priority.should == 42
  end
  
end