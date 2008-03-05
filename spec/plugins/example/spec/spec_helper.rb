require File.dirname(__FILE__) + '/../../../../lib/plugit'

Plugit.describe do |plugit|
  plugit.environment :default, 'The one we want everyone using' do |env|
    env.library :example, '1.0', "cp -R #{File.dirname(__FILE__)}/../../../repositories/example/*"
  end
end
