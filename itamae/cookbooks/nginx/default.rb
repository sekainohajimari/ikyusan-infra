package "nginx"

template "/etc/nginx/conf.d/#{node[:nginx][:application]}.conf" do
  owner "root"
  group "root"
  mode "644"
  notifies :reload, "service[nginx]"
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
