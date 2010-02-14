require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe 'Collection' do
  
  it 'should be valid' do
    new_collection.should be_valid
  end
  
  it 'should add metadata keys' do
    collection = new_collection
    collection.metadata_keys << Plongo::Elements::Input.new(:key => 'title')
    collection.metadata_keys << Plongo::Elements::Text.new(:key => 'tagline', :priority => 2)
    
    collection.metadata_keys.size.should == 2
  end
  
  it 'should have sorted elements by priority' do
    collection = new_collection
    collection.metadata_keys << Plongo::Elements::Input.new(:key => 'title', :priority => 8)
    collection.metadata_keys << Plongo::Elements::Text.new(:key => 'body', :priority => 6)
    collection.metadata_keys << Plongo::Elements::Text.new(:key => 'tagline')
    
    collection.sorted_metadata_keys.collect(&:key).should == %w{body title tagline}
  end
  
  it 'should update items from a hash' do
    item_1, item_2 = new_collection_item, new_collection_item
    
    collection = new_collection(:items => [item_1, item_2])
    
    collection.items[0].elements.first._type.should == 'Plongo::Elements::Input'

    collection.item_attributes = {
      item_1.id => {
        :element_attributes => {
          item_1.elements[0].id => { :value => 'new title', :priority => 5 },
          item_1.elements[1].id => { :value => 'new tagline' }
        }
      },
      item_2.id => {
        :element_attributes => {
          item_2.elements[1].id => { :value => 'very new tagline' }
        }
      },
      'NEW_RECORD' => {
        :name => 'New item'
      }
    }

    collection.items.size.should == 3
    
    collection.items[0].elements.first.value.should == 'new title'
    collection.items[0].elements.first.priority.should == 5
    collection.items[0].elements.first._type.should == 'Plongo::Elements::Input'
    
    collection.items[1].elements.first.value.should == 'a title'
    collection.items[1].elements[1].value.should == 'very new tagline'
    collection.items[1].elements[1]._type.should == 'Plongo::Elements::Text'

    collection.items[2]._id.should != 'NEW_RECORD'
    collection.items[2].name.should == 'New item'
  end
  
  protected
  
  def new_collection(options = {})
    Plongo::Elements::Collection.new({ :key => 'carousel', :name => 'Main carousel' }.merge(options))
  end
  
  def new_collection_item(options = {})
    Plongo::Elements::CollectionItem.new({
      :elements => [
        Plongo::Elements::Input.new(:key => 'title', :value => 'a title'),
        Plongo::Elements::Text.new(:key => 'tagline', :value => 'a tagline', :priority => 10),
        Plongo::Elements::Image.new(:key => 'picture', :value => 'a picture')
      ]}.merge(options))
  end
  
end