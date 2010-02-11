require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'Text' do
  
  it 'should be valid' do
    Plongo::Elements::Text.new(:key => 'headline', :name => 'first headline', :value => 'Lorem ipsum', :priority => 1).should be_valid
  end
  
end