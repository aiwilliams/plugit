require File.dirname(__FILE__) + '/plugit/library'
require File.dirname(__FILE__) + '/plugit/environment'
require File.dirname(__FILE__) + '/plugit/descriptor'

module Plugit
  def self.describe(&block)
    ENV['PLUGIT_ENV'] ||= 'default'
    descriptor = Descriptor.new
    block.call(descriptor)
    descriptor.install_environment(ENV['PLUGIT_ENV'])
  rescue UndefinedEnvironmentError
    puts %Q{No environment named "#{ENV['PLUGIT_ENV']}". Use one of #{descriptor.environments.collect {|e| e.name.to_s}.inspect}.}
  end
end