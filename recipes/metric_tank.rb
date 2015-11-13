packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['raintank_metric']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "nsq-metrics-tank" do
  version pkg_version
  action pkg_action
end

service "nsq_metrics_tank" do
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
