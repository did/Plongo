require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'Input' do
  
  it 'should be valid' do
    Plongo::Elements::Input.new(:key => 'title', :name => 'Header', :value => 'Lorem ipsum', :priority => 1).should be_valid
  end
  
end