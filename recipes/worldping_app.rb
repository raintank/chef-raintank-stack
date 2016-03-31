package "git"

directory "/var/lib/grafana/plugins" do
  mode "0755"
  action :create
  owner "root"
  group "root"
end

git "/var/lib/grafana/plugins/worldping-app" do
  repository "https://github.com/raintank/worldping-app.git"
  notifies :restart, 'service[grafana-server]', :delayed
  action :sync
end
