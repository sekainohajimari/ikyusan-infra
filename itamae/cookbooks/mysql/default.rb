# centos7からデフォルトでmysqlがyum installできない
execute 'Installing the official repository file' do
  command "yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"
  not_if "yum list | grep mysql56-community"
end

%w(
  epel-release
  mysql
  mysql-devel
).each do |pkg|
  package pkg
end

unless node[:mysql][:client_only]
  %w(
    mysql
    mysql-devel
    mysql-server
    mysql-utilities
  ).each do |pkg|
    package pkg
  end

  service "mysqld" do
    action :restart
  end
end
