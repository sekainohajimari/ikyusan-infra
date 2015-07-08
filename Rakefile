require 'rake'
require 'dotenv'
require 'aws-sdk-core'
require 'parallel'

Dotenv.load(
  File.join(File.dirname(File.expand_path(__FILE__)), ".env.#{ENV['INFRA_ENV']}"),
  File.join(File.dirname(File.expand_path(__FILE__)), '.env')
)

Dir.glob('lib/tasks/*.rake').each { |r| import r }
