require File.dirname(__FILE__) + '/../../../../lib/plugit'

Plugit.describe do |plugit|
  plugit.environments_root_path = File.dirname(__FILE__) + '/environments'
  
  plugit.environment :default, 'The one we want everyone using' do |env|
    env.library :example, :version => '1.0', :export => "cp -R #{File.dirname(__FILE__)}/../../../repositories/example" do |example|
      example.after_update { 'do stuff in here only after update' }
    end
  end
  plugit.environment :likedefault, 'Like default, but different after update' do |env|
    env.library :example, :version => '1.2', :extends => plugit[:default][:example] do |example|
      example.before_install { 'do stuff in here before environment install' }
    end
  end
end
