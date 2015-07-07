package "nginx"

directory "/etc/nginx/sites-enabled" do
  owner "root"
  group "root"
  mode "755"
  not_if "test -d /etc/nginx/sites-enabled"
end

template "/etc/nginx/sites-enabled/ikyusan.sekahama.club" do
  owner "root"
  group "root"
  mode "644"
  notifies :reload, "service[nginx]", :delay
end

remote_file "/etc/nginx/nginx.conf" do
  owner "root"
  group "root"
  mode "644"
  notifies :reload, "service[nginx]", :delay
end

remote_file "/etc/nginx/conf.d/log_format.conf" do
  owner "root"
  group "root"
  mode "644"
  notifies :reload, "service[nginx]", :delay
end

service "nginx" do
  action ["enable", "start"]
end

directory node[:nginx][:document_root] do
  owner node[:nginx][:document_root_user]
  group node[:nginx][:document_root_user]
  mode "775"
  not_if "test -d #{node[:nginx][:document_root]}"
end

error_res_json = "#{node[:nginx][:document_root]}/50x.json"
execute "create 50x error responce json" do
  command "echo {\"message\":\"Internal server errror\"} >> #{error_res_json}"
  not_if "test -e #{error_res_json}"
end
