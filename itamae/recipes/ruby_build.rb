RBENV_DIR = "/usr/local/rbenv"
RBENV_SCRIPT = "/etc/profile.d/rbenv.sh"

%w(
  epel-release
  gcc
  openssl-devel
  libyaml-devel
  readline-devel
  zlib-devel
  git
  libffi-devel
).each do |pkg|
  package pkg
end

git RBENV_DIR do
  repository "git://github.com/sstephenson/rbenv.git"
end

remote_file RBENV_SCRIPT do
  mode "644"
  user "root"
  source "remote_files/rbenv.sh"
end

execute "mkdir #{RBENV_DIR}/plugins" do
  not_if "test -d #{RBENV_DIR}/plugins"
end

git "#{RBENV_DIR}/plugins/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
end

node["rbenv"]["versions"].each do |versoin|
  execute "install ruby #{versoin}" do
    command "source #{RBENV_SCRIPT}; rbenv install #{versoin}"
    not_if "source #{RBENV_SCRIPT}; rbenv versions | grep #{versoin}"
  end
end

execute "set global ruby #{node["rbenv"]["global"]}" do
  command "source #{RBENV_SCRIPT}; rbenv global #{node["rbenv"]["global"]}; rbenv rehash"
  not_if "source #{RBENV_SCRIPT}; rbenv global | grep #{node["rbenv"]["global"]}"
end

node["rbenv"]["gems"].each do |gem|
  execute "gem install #{gem}" do
    command "source #{RBENV_SCRIPT}; gem install #{gem}; rbenv rehash"
    not_if "source #{RBENV_SCRIPT}; gem list | grep #{gem}"
  end
end
