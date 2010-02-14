require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'CollectionItem' do
  
  it 'should be valid' do
    Plongo::Elements::CollectionItem.new.should be_valid
  end
  
  it 'should add elements' do
    item = Plongo::Elements::CollectionItem.new
    item.elements << Plongo::Elements::Input.new(:key => 'title')
    item.elements << Plongo::Elements::Text.new(:key => 'tagline')
    
    item.elements.size.should == 2
  end
  
  it 'should have sorted elements by priority' do
    item = Plongo::Elements::CollectionItem.new
    item.elements << Plongo::Elements::Input.new(:key => 'title', :priority => 6)
    item.elements << Plongo::Elements::Input.new(:key => 'email')
    item.elements << Plongo::Elements::Text.new(:key => 'footer', :priority => 8)
    item.elements << Plongo::Elements::Text.new(:key => 'tagline', :priority => 4)
    
    item.sorted_elements.collect(&:key).should == %w{tagline title footer email}
  end
  
  it 'should retrieve an element by its key' do
    item = Plongo::Elements::CollectionItem.new
    item.elements << Plongo::Elements::Input.new(:key => 'title')
    item.elements << Plongo::Elements::Text.new(:key => 'tagline')
    
    item.find_element_by_key('title').should_not be_nil
    item.find_element_by_key('footer').should be_nil
  end
  
  it 'should update elements from a hash' do
    item = Plongo::Elements::CollectionItem.new
    item.elements << (element1 = Plongo::Elements::Input.new(:key => 'title', :value => 'a title'))
    item.elements << (element2 = Plongo::Elements::Text.new(:key => 'tagline', :value => 'a tagline', :priority => 10))
    
    item.element_attributes = [
      { :id => element1.id, :value => 'new title' },
      { :id => element2.id, :value => 'new tagline' }
    ]
    
    item.elements.first.value.should == 'new title'
    item.elements.first._type.should == 'Plongo::Elements::Input'
    
    item.elements.last.value.should == 'new tagline'
    item.elements.last._type.should == 'Plongo::Elements::Text'
    item.elements.last.priority.should == 10
  end
  
end