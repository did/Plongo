require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

describe 'Page' do
  
  before(:all) do
    Plongo::Page.destroy_all
  end
  
  it 'should find page from a path and a locale' do
    lambda {
      Plongo::Page.create!(:name => 'Home page', :path => 'pages/home', :locale => I18n.locale)
      Plongo::Page.create!(:name => 'Page accueil', :path => 'pages/home', :locale => 'fr')
    }.should change(Plongo::Page, :count).by(2)
  
    page = Plongo::Page.find_by_path_and_locale('pages/home', 'en')
    page.should_not be_nil
    page.name.should == 'Home page'
    
    page = Plongo::Page.find_by_path_and_locale('pages/home', 'fr')
    page.should_not be_nil
    page.name.should == 'Page accueil'
  end
  
end