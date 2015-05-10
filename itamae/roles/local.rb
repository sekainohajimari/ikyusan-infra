include_recipe 'selinux::disabled'

%w(
  mysql
  ruby_build
  nginx
  tz
).each do |recipe|
  include_recipe "../recipes/#{recipe}.rb"
end
