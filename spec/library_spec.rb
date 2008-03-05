require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Plugit::Library, 'creation api' do
  it 'should allow us to pass a block that receives the library for easy configuration' do
    lib_in_block = nil
    lib = Plugit::Library.new(:activerecord, '2.0.2', 'svn export http://blah') do |lib|
      lib_in_block = lib
    end
    lib_in_block.should equal(lib)
  end
end

describe Plugit::Library do
  before do
    @library = Plugit::Library.new(:activerecord, '2.0.2', 'svn export http://blah')
    @environment = Plugit::Environment.new(:standard, 'For testing libraries')
    @environment.stub!(:library_root_path).and_return('/some/root')
    @target_path = '/some/root/activerecord/2.0.2'
  end
  
  it 'should answer the name' do
    @library.name.should == :activerecord
  end
  
  it 'should answer the version' do
    @library.version.should == '2.0.2'
  end
  
  it 'should answer the scm export command' do
    @library.scm_export_command.should == 'svn export http://blah'
  end
  
  describe 'load paths' do
    it 'should allow the addition of paths' do
      @library.load_paths << '/some/path'
      @library.load_paths.should include('/some/path')
    end
    
    it 'should allow the assignment of paths' do
      @library.load_paths = []
    end
    
    it 'should answer the default as /lib' do
      @library.load_paths.should == ['/lib']
    end
  end
  
  describe 'requires' do
    it 'should allow the addition of things to require on load' do
      @library.requires << '/some/thing'
      @library.requires.should include('/some/thing')
    end
    
    it 'should allow the assignment of requires' do
      @library.requires = []
    end
  end
  
  describe 'Environment installing' do
    it 'should add it\'s load path, then make all requires' do
      @library.requires = ['/some/thing']
      @library.load_paths = ['/some/where']
      $LOAD_PATH.should_receive(:<<).with(@target_path + '/some/where')
      Object.should_receive(:require).with('/some/thing')
      @library.install(@environment)
    end
  end
  
  describe 'Environment updating' do
    it 'should check out into the environment root path' do
      @library.should_receive(:checkout).with(@target_path)
      @library.update(@environment)
    end
    
    describe 'where library is already checked out' do
      before do
        File.stub!(:directory?).and_return(true)
      end
      
      it 'should not update the library' do
        @library.should_not_receive(:checkout)
        @library.update(@environment)
      end
      
      it 'should update if forced' do
        FileUtils.should_receive(:rm_rf).with(@target_path)
        @library.should_receive(:checkout).with(@target_path)
        @library.update(@environment, true)
      end
    end
  end
end
