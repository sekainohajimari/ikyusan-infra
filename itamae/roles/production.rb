require 'dotenv'
Dotenv.load

%w(
  ruby_build
  nokogiri-env
  nginx
  tz
  mackerel
).each do |recipe|
  include_recipe "../cookbooks/#{recipe}/default.rb"
end
