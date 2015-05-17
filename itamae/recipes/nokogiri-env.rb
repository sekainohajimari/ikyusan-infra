%w(
  libxml2-devel
  libxslt-devel
).each do |package_name|
  package package_name
end

RBENV_SCRIPT = "/etc/profile.d/rbenv.sh"

execute "modify bundle config for nokogiri" do
  user 'vagrant'
  command <<-EOS
  source #{RBENV_SCRIPT}
  bundle config build.nokogiri --use-system-libraries
  EOS
  not_if <<-EOS
  source #{RBENV_SCRIPT}
  bundle config | grep build.nokogiri
  EOS
end
