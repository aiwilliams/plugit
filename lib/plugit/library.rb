require 'fileutils'

module Plugit
  class Library
    include FileUtils
    
    attr_accessor :load_paths, :requires
    attr_reader   :name, :version, :scm_export_command
    
    def initialize(name, version, scm_export_command)
      @name, @version, @scm_export_command = name, version, scm_export_command
      @load_paths = ['/lib']
      @requires = []
      yield self if block_given?
    end
    
    def after_update(&block)
      @after_update = block
    end
    
    def checkout(target_path)
      command = "#{scm_export_command} #{target_path}"
      puts "Checking out #{name}: #{command}"
      `#{command}`
    end
    
    def install(environment)
      load_paths.each { |l| $LOAD_PATH << File.join(target_path(environment), l) }
      Object.send :require, *requires unless requires.empty?
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
    
    protected
      def target_path(environment)
        File.join(environment.library_root_path, name.to_s, version)
      end
  end
end