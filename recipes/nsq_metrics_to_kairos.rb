packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['raintank_metric']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "nsq-metrics-to-kairos" do
  version pkg_version
  action pkg_action
  options "-o Dpkg::Options::='--force-confnew'"
end

service "nsq_metrics_to_kairos" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start ]
end

nsqd_addrs = find_nsqd || node['raintank_stack']['nsq_tools']['metrics_to_kairos']['nsqd_addr']

directory "/etc/raintank" do
  owner "root"
  group "root"
  mode "0644"
  recursive true
  action :create
end

template "/etc/raintank/nsq_metrics_to_kairos.ini" do
  source "nsq_metrics_to_kairos.ini.erb"
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables({
    :channel => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['channel'],
    :lookupd => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['lookupd'],
    :max_in_flight => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['max_in_flight'],
    :concurrency => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['concurrency'],
    :consumer => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['consumer'],
    :producer => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['producer'],
    :nsqd_addr => nsqd_addrs.join(','),
    :statsd_addr => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['statsd_addr'],
    :statsd_type => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['statsd_type'],
    :topic => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['topic'],
    :topic_low => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['topic_low'],
    :kairos_addr => node['raintank_stack']['nsq_tools']['metrics_to_kairos']['kairos_addr'],
    :listen =>  node['raintank_stack']['nsq_tools']['metrics_to_kairos']['listen']
  })
  notifies :restart, "service[nsq_metrics_to_kairos]"
end
