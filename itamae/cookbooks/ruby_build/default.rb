# rbenv,rb_buildに必要なパッケージをインストールする
%w(
  epel-release
  gcc
  gcc-c++
  openssl-devel
  libyaml-devel
  readline-devel
  zlib-devel
  git
).each do |package_name|
  package package_name
end

RBENV_DIR = "/usr/local/rbenv"
RBENV_SCRIPT = "/etc/profile.d/rbenv.sh"

git RBENV_DIR do
  repository "https://github.com/sstephenson/rbenv.git"
end

directory "#{RBENV_DIR}/shims" do
  not_if "test -d #{RBENV_DIR}/shims"
end

directory "#{RBENV_DIR}/versions" do
  not_if "test -d #{RBENV_DIR}/versions"
end

remote_file RBENV_SCRIPT do
  mode '644'
end

directory "#{RBENV_DIR}/plugins" do
  not_if "test -d #{RBENV_DIR}/plugins"
end

git "#{RBENV_DIR}/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
end

node[:rbenv][:versions].each do |versoin|
  execute "install ruby #{versoin}" do
    command <<-EOS
    source #{RBENV_SCRIPT}
    rbenv install #{versoin}
    EOS
    not_if <<-EOS
    source #{RBENV_SCRIPT}
    rbenv versions | grep #{versoin}
    EOS
  end
end

execute "set global ruby #{node[:rbenv][:global]}" do
  command <<-EOS
  source #{RBENV_SCRIPT}
  rbenv global #{node[:rbenv][:global]}
  rbenv rehash
  EOS
  not_if <<-EOS
  source #{RBENV_SCRIPT}
  rbenv global | grep #{node[:rbenv][:global]}
  EOS
end

node[:rbenv][:gems].each do |gem|
  execute "gem install #{gem[:name]}" do
    command <<-EOS
    source #{RBENV_SCRIPT}
    gem install #{gem[:name]} #{gem[:version] ? "-v #{gem[:version]}" : ''} --no-ri --no-rdoc;
    rbenv rehash
    EOS
    not_if <<-EOS
    source #{RBENV_SCRIPT}
    gem list | grep #{gem[:name]}
    EOS
  end
end
