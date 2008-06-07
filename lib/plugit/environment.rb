module Plugit
  class Environment
    attr_reader :name, :description
    
    def initialize(name, description, root_path)
      @name, @description, @root_path = name, description, root_path
      @libraries = []
    end
    
    def [](library_name)
      @libraries.detect {|l|l.name == library_name}
    end
    
    def add_library(library)
      @libraries << library
    end
    
    def libraries
      @libraries.dup
    end
    
    def library_root_path
      File.join(@root_path, name.to_s)
    end
  end
end