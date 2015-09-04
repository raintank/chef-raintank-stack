packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['raintank_metric']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "nsq_metrics_to_elasticsearch" do
  version pkg_version
  action pkg_action
end

service "nsq_metrics_to_elasticsearch" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start ]
end

template "/etc/init/nsq_metrics_to_elasticsearch.conf" do
  source "nsq_metrics_to_elasticsearch.conf.erb"
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables({
    :channel => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['channel'],
    :lookupd => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['lookupd'],
    :max_in_flight => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['max_in_flight'],
    :consumer => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['consumer'],
    :num_msg => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['num_msg'],
    :nsqd_addr => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['nsqd_addr'],
    :statsd_addr => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['statsd_addr'],
    :statsd_type => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['statsd_type'],
    :topic => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['topic']
  })
  notifies :restart, "service[nsq_metrics_to_elasticsearch]"
end
