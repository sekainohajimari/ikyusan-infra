require 'dotenv'
Dotenv.load

node['recipes'] = node['recipes'] || []

node['recipes'].each do |recipe|
  include_recipe "roles/#{recipe}.rb"
end
