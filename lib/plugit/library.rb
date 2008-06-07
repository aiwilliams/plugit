require 'fileutils'

module Plugit
  class Library
    include FileUtils
    
    attr_accessor :load_paths, :requires
    attr_reader   :configuration, :name
    
    def initialize(name, configuration = {})
      @name = name
      @configuration = {}
      if extending = configuration[:extends]
        @configuration.update(extending.configuration)
        @load_paths = extending.load_paths.dup
        @requires = extending.requires.dup
      end
      @configuration.update(configuration)
      
      @load_paths ||= ['/lib']
      @requires ||= []
      
      yield self if block_given?
    end
    
    def after_update(&block)
      @after_update = block
    end
    
    def before_install(&block)
      @before_install = block
    end
    
    def checkout(target_path)
      command = "#{export} #{target_path}"
      puts "Checking out #{name}: #{command}"
      `#{command}`
    end
    
    def install(environment)
      target_path = self.target_path(environment)
      cd(target_path) do
        instance_eval(&@before_install)
      end if @before_install
      load_paths.reverse.each { |l| $LOAD_PATH.unshift File.join(target_path, l) }
      requires.each { |r| Object.send :require, r }
    end
    
    def method_missing(method, *args)
      if value = @configuration[method.to_sym]
        value
      else
        super(method, *args)
      end
    end
    
    def target_path(environment)
      paths = [environment.library_root_path, name.to_s]
      paths << version if version
      File.join(paths)
    end
    
    def update(environment, force = false)
      target_path = self.target_path(environment)
      mkdir_p(File.dirname(target_path))
      if !File.directory?(target_path) || force
        rm_rf(target_path)
        checkout(target_path)
        cd(target_path) do
          instance_eval(&@after_update)
        end if @after_update
      end
    end
    
    def version
      @configuration[:version]
    end
  end
end