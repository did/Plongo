require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'Base controller' do
  
  before(:all) do
    @controller = MyController.new    
  end
  
  it 'should keep the last page' do
    page = Plongo::Page.new(:name => 'About', :path => 'pages/about')
    @controller.send(:append_plongo_page, page)
    page = Plongo::Page.new(:name => 'Home page', :path => 'pages/home')
    @controller.send(:append_plongo_page, page)
    page = Plongo::Page.new(:name => 'Home page *', :path => 'pages/home')
    @controller.send(:append_plongo_page, page)
    
    pages = @controller.instance_variable_get(:@plongo_pages)
    pages.size.should == 2
    pages.last.name.should == 'Home page *'
  end
  
  
end