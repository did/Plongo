require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'BaseViewHelper' do
  
  def content_tag(*args); true; end
    
  include Plongo::Rails::BaseViewHelper
  
  it 'should return Input class' do
    %w{h1 h2 h3 h4 h5 a em small em b u i strong}.each do |tag|
      name_to_plongo_element_klass(tag).should == Plongo::Elements::Input
    end
  end
  
  it 'should return Text class' do
    %w{div p quote pre code}.each do |tag|
      name_to_plongo_element_klass(tag).should == Plongo::Elements::Text
    end    
  end
  
  it 'should return Image class' do
    name_to_plongo_element_klass(:img).should == Plongo::Elements::Image
  end
  
  it 'should return Collection class' do
    %w{div ul ol dl table tbody}.each do |tag|
      name_to_plongo_element_klass(tag) do
        true
      end.should == Plongo::Elements::Collection
    end
  end
  
end