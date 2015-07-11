execute 'Installing the official repository file' do
  command "curl -fsSL https://mackerel.io/assets/files/scripts/setup-yum.sh | sh"
  not_if "yum list | grep mackerel-agent"
end

package "mackerel-agent"

service "mackerel-agent" do
  user 'root'
  action :restart
end

execute 'Setting mackerel config' do
  user 'root'
  command <<-EOS
  echo apikey = "#{Global.secret.mackerel.apikey}" >> /etc/mackerel-agent/mackerel-agent.conf
  EOS
  not_if "test -e /etc/mackerel-agent/mackerel-agent.conf"
  notifies :restart, "service[mackerel-agent]", :delay
end
