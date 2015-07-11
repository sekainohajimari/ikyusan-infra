require_relative '../lib/global_setting.rb'

node['recipes'] = node['recipes'] || []

node['recipes'].each do |recipe|
  include_recipe "roles/#{recipe}.rb"
end
