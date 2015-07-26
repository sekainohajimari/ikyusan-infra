execute "yum groupinstall -y \"Development Tools\""

%w(
  cmake
  libyaml-devel
  openssl-devel
).each do |pkg|
  package pkg
end

remote_file "/etc/systemd/system/h2o.service" do
  owner "root"
  group "root"
  mode "644"
end
execute "systemctl daemon-reload"

directory node[:h2o][:document_root] do
  owner node[:h2o][:document_root_user]
  group node[:h2o][:document_root_user]
  mode "775"
  not_if "test -d #{node[:h2o][:document_root]}"
end

directory node[:h2o][:log_dir] do
  not_if "test -d #{node[:h2o][:log_dir]}"
end

directory node[:h2o][:run_dir] do
  mode "775"
  not_if "test -d #{node[:h2o][:run_dir]}"
end

service "h2o"

git "/usr/local/src/h2o" do
  repository "https://github.com/kazuho/h2o.git"
  revision node[:h2o][:version]
end

execute "Install h2o" do
  command <<-EOS
  cd /usr/local/src/h2o
  git submodule update --init --recursive
  cmake -DWITH_MRUBY=ON .
  make h2o
  make install
  EOS
  not_if "ls /usr/local/share/h2o"
end

template "/usr/local/share/h2o/h2o.conf" do
  owner "root"
  group "root"
  mode "644"
  notifies :restart, "service[h2o]", :delay
end
