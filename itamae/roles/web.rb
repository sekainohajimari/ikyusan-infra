%w(
  env-variable
  ruby_build
  mruby
  nokogiri-env
  h2o
  tz
  logrotate
).each do |recipe|
  include_recipe "../cookbooks/#{recipe}/default.rb"
end
