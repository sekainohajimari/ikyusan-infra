require 'global'

$infra_env = ENV.fetch('INFRA_ENV', 'development')

Global.configure do |config|
  config.environment = ENV.fetch('INFRA_ENV', 'development')
  config.config_directory = File.expand_path('../../config/global', __FILE__)
end
