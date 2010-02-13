require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'BaseViewHelper' do
  
  def content_tag(*args); true; end
    
  include Plongo::Rails::BaseViewHelper
  
  it 'should return the right element type' do
    %w{h1 h2 h3 h4 h5 a em small em b u i strong}.each do |tag|
      name_to_plongo_element_klass(tag).should == Plongo::Elements::Input
    end
    %w{div p quote pre code}.each do |tag|
      name_to_plongo_element_klass(tag).should == Plongo::Elements::Text
    end
    name_to_plongo_element_klass(:img).should == Plongo::Elements::Image
  end
  
end