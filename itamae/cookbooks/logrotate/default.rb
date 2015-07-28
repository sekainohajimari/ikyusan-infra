%w(
  rails
  h2o
).each do |rotate|
  template "/etc/logrotate.d/#{rotate}" do
    owner "root"
    group "root"
    mode "644"
  end
end
