require File.dirname(__FILE__) + '/plugit/library'
require File.dirname(__FILE__) + '/plugit/environment'
require File.dirname(__FILE__) + '/plugit/descriptor'

module Plugit
  def self.describe(&block)
    descriptor = Descriptor.new
    block.call(descriptor)
    descriptor.install_environment(ENV['PLUGIT_ENV'] || :default)
  end
end