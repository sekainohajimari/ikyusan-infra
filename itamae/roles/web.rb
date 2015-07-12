%w(
  env-variable
  ruby_build
  nokogiri-env
  nginx
  tz
  logrotate
).each do |recipe|
  include_recipe "../cookbooks/#{recipe}/default.rb"
end
