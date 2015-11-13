packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['raintank_metric']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "nsq-metrics-to-elasticsearch" do
  version pkg_version
  action pkg_action
  case node["platform"]
  when "ubuntu"
    options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew"'
  end
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

nsqd_addrs = find_nsqd || node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['nsqd_addr']

template "/etc/raintank/nsq_metrics_to_elasticsearch.ini" do
  source "nsq_metrics_to_elasticsearch.ini.erb"
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables({
    :channel => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['channel'],
    :lookupd => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['lookupd'],
    :max_in_flight => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['max_in_flight'],
    :consumer => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['consumer'],
    :nsqd_addr => nsqd_addrs.join(','),
    :statsd_addr => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['statsd_addr'],
    :statsd_type => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['statsd_type'],
    :topic => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['topic'],
    :elastic_addr => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['elastic_addr'],
    :redis_addr => node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['redis_addr'],
    :listen =>  node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['listen']
  })
  notifies :restart, "service[nsq_metrics_to_elasticsearch]"
end
