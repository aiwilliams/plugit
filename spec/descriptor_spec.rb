require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Plugit::Descriptor do
  before do
    @descriptor = Plugit::Descriptor.new
    @descriptor.environments_root_path = 'env/root/path'
  end
  
  it 'should allow the definition of environments' do
    environment = @descriptor.environment :default, 'The description' do |env|
      env.library :something, 'version', 'export command' do |lib|
        lib.load_paths = ['some/load/path']
      end
    end
    environment.libraries.first.load_paths.should == ['some/load/path']
  end
end