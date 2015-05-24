%w(
  ruby_build
  nokogiri-env
  nginx
  tz
).each do |recipe|
  include_recipe "../recipes/#{recipe}.rb"
end
