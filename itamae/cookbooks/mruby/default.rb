MRUBY_DIR = "/usr/local/mruby"
RBENV_SCRIPT = "/etc/profile.d/rbenv.sh"

package "bison"

git MRUBY_DIR do
  repository "https://github.com/mruby/mruby.git"
end

execute "Build mruby" do
  command <<-EOS
  source #{RBENV_SCRIPT}
  mgem update
  cd #{MRUBY_DIR}
  mgem config default > build_config.rb
  rake
  cp build/host/lib/libmruby.a build/host/lib/libmruby_core.a /usr/lib/. && cp -r include/* /usr/include/.
  EOS
end

execute "add mruby path" do
  command "ln -s /usr/local/mruby/bin/mruby /usr/bin/mruby"
  not_if "ls /usr/bin/mruby"
end
