module Plugit
  class Environment
    class UninitializedRootError < StandardError; end
    
    class << self
      attr_accessor :library_root_path
    end
    
    attr_reader :name, :description
    
    def initialize(name, description)
      @name, @description = name, description
      @libraries = []
    end
    
    def add_library(library)
      @libraries << library
    end
    
    def libraries
      @libraries.dup
    end
    
    def library_root_path
      root_path = self.class.library_root_path
      raise UninitializedRootError unless root_path
      File.join(root_path, name.to_s)
    end
  end
end