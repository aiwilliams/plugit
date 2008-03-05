module Plugit
  class Descriptor
    attr_writer :library_root_path
    
    def initialize
      @environments = []
    end
    
    def environment(*init_args, &block)
      @environments << (env = Environment.new(*init_args))
      block.call(EnvironmentBuilder.new(env))
    end
    
    def install_environment(name)
      Environment.library_root_path = @library_root_path || File.expand_path('environments')
      env = @environments.detect {|e| e.name == name.to_sym}
      env.libraries.each do |lib|
        lib.update(env)
        lib.install(env)
      end
    end
  end
  
  class EnvironmentBuilder
    def initialize(env)
      @env = env
    end
    
    def library(*init_args)
      @env.add_library(Library.new(*init_args))
    end
  end
end