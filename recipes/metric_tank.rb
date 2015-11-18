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
  options "-o Dpkg::Options::='--force-confnew'"
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

directory "/etc/raintank" do
  owner "root"
  group "root"
  mode "0644"
  recursive true
  action :create
end

dump_dir = ::File.dirname(node['raintank_stack']['nsq_tools']['metric_tank']['dump_file'])
directory dump_dir do 
  owner "root"
  group "root"
  mode "0755"
  recursive true
  not_if { ::File.exist?(dump_dir) }
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
    :max_in_flight => node['raintank_stack']['nsq_tools']['metric_tank']['max_in_flight'],
    :concurrency => node['raintank_stack']['nsq_tools']['metric_tank']['concurrency'],
    :listen => node['raintank_stack']['nsq_tools']['metric_tank']['listen'],
    :ttl => node['raintank_stack']['nsq_tools']['metric_tank']['ttl'],
    :chunkspan => node['raintank_stack']['nsq_tools']['metric_tank']['chunkspan'],
    :numchunks => node['raintank_stack']['nsq_tools']['metric_tank']['numchunks'], 
    :cassandras => cassandra_addrs.join(','),
    :cassandra_write_concurrency => node['raintank_stack']['nsq_tools']['metric_tank']['cassandra_write_concurrency'],
    :nsqds => nsqd_addrs.join(','),
    :dump_file => node['raintank_stack']['nsq_tools']['metric_tank']['dump_file'],
    :log_level => node['raintank_stack']['nsq_tools']['metric_tank']['log_file'],
    :gc_interval => node['raintank_stack']['nsq_tools']['metric_tank']['gc_interval'],
    :chunk_max_stale => node['raintank_stack']['nsq_tools']['metric_tank']['chunk_max_stale'],
    :metric_max_stale => node['raintank_stack']['nsq_tools']['metric_tank']['metric_max_stale'],
    :statsd_addr => node['raintank_stack']['nsq_tools']['metric_tank']['statsd_addr'],
    :statsd_type => node['raintank_stack']['nsq_tools']['metric_tank']['statsd_type']
  })
  notifies :restart, "service[metric_tank]"
end
