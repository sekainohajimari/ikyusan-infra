require 'rake'
require 'dotenv'

Dotenv.load(
  File.join(File.dirname(File.expand_path(__FILE__)), ".env.#{ENV['INFRA_ENV']}"),
  File.join(File.dirname(File.expand_path(__FILE__)), '.env')
)

Dir.glob('lib/tasks/*.rake').each { |r| import r }
