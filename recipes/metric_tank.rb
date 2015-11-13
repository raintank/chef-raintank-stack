packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['raintank_metric']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "metric-tank" do
  version pkg_version
  action pkg_action
end

service "metric_tank" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start ]
end

nsqd_addrs = find_nsqd || node['raintank_stack']['nsq_tools']['metrics_to_tank']['nsqd_addr']
cassandra_addrs = find_cassandras

# once raintank-metric#45 is accepted, this can be finished with a config file

directory "/etc/raintank" do
  owner "root"
  group "root"
  mode "0644"
  recursive true
  action :create
end

template "/etc/raintank/metric_tank.ini" do
  source "metric_tank.ini.erb"
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables({
    :channel => node['raintank_stack']['nsq_tools']['metric_tank']['channel'],
    :topic => node['raintank_stack']['nsq_tools']['metric_tank']['topic'],
    :listen => node['raintank_stack']['nsq_tools']['metric_tank']['listen'],
    :cassandras => cassandra_addrs.join(',')
    :nsqds => nsqds.join(',')
  })
  notifies :restart, "service[metric_tank]"
end
