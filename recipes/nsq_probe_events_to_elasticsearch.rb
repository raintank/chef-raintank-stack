packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['raintank_metric']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "nsq-probe-events-to-elasticsearch" do
  version pkg_version
  action pkg_action
  options "-o Dpkg::Options::='--force-confnew'"
end

service "nsq_probe_events_to_elasticsearch" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start ]
end

nsqd_addrs = find_nsqd || node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['nsqd_addr']
ea = find_haproxy
elastic_addr = if ea
  "#{ea}:9200"
else
  node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['elastic_addr']
end  

directory "/etc/raintank" do
  owner "root"
  group "root"
  mode "0644"
  recursive true
  action :create
end

template "/etc/raintank/nsq_probe_events_to_elasticsearch.ini" do
  source "nsq_probe_events_to_elasticsearch.ini.erb"
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables({
    :channel => node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['channel'],
    :lookupd => node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['lookupd'],
    :max_in_flight => node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['max_in_flight'],
    :consumer => node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['consumer'],
    :nsqd_addr => nsqd_addrs.join(','),
    :statsd_addr => node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['statsd_addr'],
    :statsd_type => node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['statsd_type'],
    :topic => node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['topic'],
    :elastic_addr => elastic_addr,
    :listen =>  node['raintank_stack']['nsq_tools']['probe_events_to_elasticsearch']['listen']
  })
  notifies :restart, "service[nsq_probe_events_to_elasticsearch]"
end
