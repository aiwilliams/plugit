require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Plugit::Library, 'creation api' do
  it 'should allow us to pass a block that receives the library for easy configuration' do
    lib_in_block = nil
    lib = Plugit::Library.new(:activerecord) do |lib|
      lib_in_block = lib
    end
    lib_in_block.should equal(lib)
  end
end

describe Plugit::Library do
  before do
    @library = Plugit::Library.new(:activerecord, :version => '2.0.2', :export => 'svn export http://blah')
    @environment = Plugit::Environment.new(:standard, 'For testing libraries', '/some/root')
    @target_path = '/some/root/standard/activerecord/2.0.2'
  end
  
  it 'should answer the name' do
    @library.name.should == :activerecord
  end
  
  it 'should answer the version' do
    @library.version.should == '2.0.2'
  end
  
  it 'should answer the scm export command' do
    @library.export.should == 'svn export http://blah'
  end
  
  it 'should answer a target path with environments root, environment name, library name and version' do
    @library.target_path(@environment).should == @target_path
  end
  
  it 'should answer a target path without a version' do
    @library = Plugit::Library.new(:activerecord)
    @library.version.should be_nil
    @library.target_path(@environment).should == File.dirname(@target_path)
  end
  
  it 'should be able to assume attributes from another library' do
    assuming_library = Plugit::Library.new(:assuming, :extends => @library, :version => '2.0.3')
    assuming_library.name.should == :assuming
    assuming_library.version.should == '2.0.3'
    assuming_library.export.should == @library.export
    assuming_library.load_paths.should == @library.load_paths
    assuming_library.requires.should == @library.requires
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
    before do
      @library.requires = ['/some/thing', '/else']
      @library.load_paths = ['/some/where', '/otherplace']
      $LOAD_PATH.stub!(:unshift)
      Object.stub!(:require)
    end
    
    it 'should add it\'s load paths, in correct order, to the front of the load path to get in front of rubygems' do
      $LOAD_PATH.should_receive(:unshift).with(@target_path + '/otherplace').ordered
      $LOAD_PATH.should_receive(:unshift).with(@target_path + '/some/where').ordered
      @library.install(@environment)
    end
    
    it 'should require each of the library requires' do
      Object.should_receive(:require).with('/some/thing')
      Object.should_receive(:require).with('/else')
      @library.install(@environment)
    end
    
    it 'should invoke before_install block against library instance, in target directory' do
      class << @library
        attr_reader :cdpath
        def cd(cdpath)
          @cdpath = cdpath
          yield
        end
      end
      
      @library.before_install { call_from_before_install }
      @library.should_receive(:call_from_before_install)
      @library.install(@environment)
      @library.cdpath.should == @target_path
    end
  end
  
  describe 'Environment updating' do
    before do
      @library.stub!(:checkout)
      @library.stub!(:cd)
      @library.stub!(:rm_rf)
      @library.stub!(:mkdir_p)
    end
    
    it 'should create the parent directory where the library will be exported into' do
      @library.should_receive(:mkdir_p).with(File.dirname(@target_path))
      @library.update(@environment)
    end
    
    it 'should check out into the environment root path' do
      @library.should_receive(:checkout).with(@target_path)
      @library.update(@environment)
    end
    
    it 'should invoke after_update block against library instance, in target directory' do
      class << @library
        attr_reader :cdpath
        def cd(cdpath)
          @cdpath = cdpath
          yield
        end
      end
      
      @library.after_update { call_from_update }
      @library.should_receive(:call_from_update)
      @library.update(@environment)
      @library.cdpath.should == @target_path
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
        @library.should_receive(:rm_rf).with(@target_path)
        @library.should_receive(:checkout).with(@target_path)
        @library.update(@environment, true)
      end
    end
  end
end
