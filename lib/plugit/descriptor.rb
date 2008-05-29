module Plugit
  class Descriptor
    attr_writer :environments_root_path
    
    def initialize
      @environments = []
    end
    
    def environment(*init_args, &block)
      init_args << File.expand_path(@environments_root_path || 'environments')
      @environments << (env = Environment.new(*init_args))
      block.call(EnvironmentBuilder.new(env))
      env
    end
    
    def install_environment(name)
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
    
    def library(*init_args, &block)
      @env.add_library(Library.new(*init_args, &block))
    end
  end
end