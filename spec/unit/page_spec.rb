require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'Page' do
  
  it 'should be valid' do
    Plongo::Page.new(:name => 'Home page', :path => 'pages/home').should be_valid
  end
  
  it 'should add elements' do
    page = Plongo::Page.new(:name => 'Home page')
    page.elements << Plongo::Elements::Input.new(:key => 'title')
    page.elements << Plongo::Elements::Text.new(:key => 'tagline')
    
    page.elements.size.should == 2
  end
  
  it 'should have sorted elements by priority' do
    page = Plongo::Page.new(:name => 'Home page')
    page.elements << Plongo::Elements::Input.new(:key => 'title', :priority => 6)
    page.elements << Plongo::Elements::Input.new(:key => 'email')
    page.elements << Plongo::Elements::Text.new(:key => 'footer', :priority => 8)
    page.elements << Plongo::Elements::Text.new(:key => 'tagline', :priority => 4)
    
    page.sorted_elements.collect(&:key).should == %w{tagline title footer email}
  end
  
  it 'should retrieve an element by its key' do
    page = Plongo::Page.new(:name => 'Home page')
    page.elements << Plongo::Elements::Input.new(:key => 'title')
    page.elements << Plongo::Elements::Text.new(:key => 'tagline')
    
    page.find_element_by_key('title').should_not be_nil
    page.find_element_by_key('footer').should be_nil
  end
  
  it 'should update elements from a hash' do
    page = Plongo::Page.new(:name => 'Home page')    
    page.elements << (element1 = Plongo::Elements::Input.new(:key => 'title', :value => 'a title'))
    page.elements << (element2 = Plongo::Elements::Text.new(:key => 'tagline', :value => 'a tagline', :priority => 10))
    
    page.element_attributes = {
      element1.id => { :value => 'new title' },
      element2.id => { :value => 'new tagline' }
    }
    
    page.elements.first.value.should == 'new title'
    page.elements.first._type.should == 'Plongo::Elements::Input'
    
    page.elements.last.value.should == 'new tagline'
    page.elements.last._type.should == 'Plongo::Elements::Text'
    page.elements.last.priority.should == 10
  end
  
end