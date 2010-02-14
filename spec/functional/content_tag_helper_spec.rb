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
  
  # it 'should handle empty collection' do
  #   content_tag(:ul, :plongo => { :key => 'simple_collection', :name => 'Simple collection' }) do |el|
  #     # puts el.to_s
  #     # puts el.content_tag(:p, 'hello')
  #     # puts el.content_tag(:p, 'world')
  #     # el.content_tag(:li, 'Lorem ipsum')
  #     # concat('<li>Lorem ipsum</li>')
  #   end.should == '<ul>empty</ul>'
  # end
    
  # it 'should handle empty collection' do
  #   content_tag(:ul, :plongo => { :key => 'simple_collection', :name => 'Simple collection' }) do |el|
  #     true
  #   end
  #     
  #   content_tag(:ul, :plongo => { :key => 'simple_collection', :name => 'Simple collection' }) do |el|
  #     concat("<li>" + content_tag("")
  #     content_tag(:li, el.value)
  #   end.should == '<ul><li>Hello</li><li>World</li</ul>'
  # end
  
  it 'should setup a collection' do
    render_collection.should == '<ul><li><h2>Item title</h2><div>Item description</div></li></ul>'
    
    (collection = Plongo::Page.find_by_path('pages/home').elements.first).should_not be_nil
    collection.metadata_keys.should_not be_empty
    collection.metadata_keys.collect(&:key).should == %w{title body}
    collection.items.should be_empty
    
    # does not change anything
    render_collection.should == '<ul><li><h2>Item title</h2><div>Item description</div></li></ul>'    
  end
  
  it 'should render multiple items of a collection' do
    render_collection
    
    page = Plongo::Page.find_by_path('pages/home')
    collection = page.elements.first
    
    collection.items << new_collection_item('Hello world', 'Lorem ipsum...')
    collection.items << new_collection_item('Foo bar', 'Lorem ipsum...etc')
    
    page.save
    
    @plongo_page = nil # reset
        
    render_collection.should == '<ul><li><h2>Hello world</h2><div>Lorem ipsum...</div></li><li><h2>Foo bar</h2><div>Lorem ipsum...etc</div></li></ul>'
  end
  
  protected
  
  def render_collection
    content_tag(:ul, :plongo => { :key => 'simple_collection', :name => 'Simple collection' }) do
      content_tag(:li) do
        content_tag(:h2, 'Item title', :plongo_key => 'title') +
        content_tag(:div, 'Item description', :plongo_key => 'body')
      end
    end
  end
  
  def new_collection_item(title, body)
    item = Plongo::Elements::CollectionItem.new
    item.elements << Plongo::Elements::Input.new(:key => 'title', :value => title)
    item.elements << Plongo::Elements::Text.new(:key => 'body', :value => body)
    item
  end
  
end