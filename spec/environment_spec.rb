require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Plugit::Environment do
  before do
    @environment = Plugit::Environment.new(:standard, 'Example of environment')
  end
  
  it 'should answer the name' do
    @environment.name.should == :standard
  end
  
  it 'should answer the description' do
    @environment.description.should == 'Example of environment'
  end
  
  it 'should tell us to configure Environment.library_root_path' do
    lambda do
      @environment.library_root_path
    end.should raise_error(Plugit::Environment::UninitializedRootError)
  end
  
  it 'should answer the library root path relative Environment.library_root_path' do
    Plugit::Environment.library_root_path = '/some/root/path'
    @environment.library_root_path.should == '/some/root/path/standard'
  end
  
  it 'should allow the addition of libraries' do
    library = mock(Plugit::Library)
    @environment.add_library library
    @environment.libraries.should include(library)
  end
  
  it 'should answer a dup of our libraries so we control what\'s in our list' do
    @environment.libraries.should_not equal(@environment.libraries)
  end
end