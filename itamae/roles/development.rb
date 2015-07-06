require 'dotenv'
Dotenv.load

include_recipe 'selinux::disabled'

%w(
  mysql
  ruby_build
  nokogiri-env
  nginx
  tz
  logrotate
).each do |recipe|
  include_recipe "../cookbooks/#{recipe}/default.rb"
end
