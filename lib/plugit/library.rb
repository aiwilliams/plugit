require 'fileutils'

module Plugit
  class Library
    attr_accessor :load_paths, :requires
    attr_reader   :name, :version, :scm_export_command
    
    def initialize(name, version, scm_export_command)
      @name, @version, @scm_export_command = name, version, scm_export_command
      @load_paths = ['/lib']
      @requires = []
      yield self if block_given?
    end
    
    def checkout(target_path)
      FileUtils.mkdir_p(target_path)
      `#{scm_export_command} #{target_path}`
    end
    
    def install(environment)
      load_paths.each { |l| $LOAD_PATH << File.join(target_path(environment), l) }
      Object.send :require, *requires unless requires.empty?
    end
    
    def update(environment, force = false)
      target_path = self.target_path(environment)
      if !File.directory?(target_path) || force
        FileUtils.rm_rf(target_path)
        checkout(target_path)
      end
    end
    
    protected
      def target_path(environment)
        File.join(environment.library_root_path, name.to_s, version)
      end
  end
end