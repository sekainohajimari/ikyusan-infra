MACKEREL_CONFIG = "/etc/mackerel-agent/mackerel-agent.conf"

execute 'Installing the official repository file' do
  command "curl -fsSL https://mackerel.io/assets/files/scripts/setup-yum.sh | sh"
  not_if "yum list | grep mackerel-agent"
end

package "mackerel-agent"
service "mackerel-agent"

execute 'Setting mackerel config' do
  command "echo 'apikey = \"#{Global.secret.mackerel.apikey}\"' >> #{MACKEREL_CONFIG}"
  not_if "grep 'apikey = \"#{Global.secret.mackerel.apikey}\"' #{MACKEREL_CONFIG}"
  notifies :restart, "service[mackerel-agent]", :delay
end
