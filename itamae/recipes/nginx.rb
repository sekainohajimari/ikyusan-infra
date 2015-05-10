package "nginx"

remote_file "/etc/nginx/conf.d/ikyusan.conf" do
  owner "root"
  group "root"
  source "remote_files/ikyusan.conf"
  notifies :reload, "service[nginx]"
end

service "nginx" do
  action :start
  not_if "pgrep nginx"
end
