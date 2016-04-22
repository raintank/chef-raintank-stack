group node[:raintank_stack]['worldping-api']['group'] do
  system true
  action :create
  not_if "getent group #{node[:raintank_stack]['worldping-api']['group']}"
end

user node[:raintank_stack]['worldping-api']['user'] do
  system true
  gid node[:raintank_stack]['worldping-api']['group']
  home node[:raintank_stack]['worldping-api']['data_dir']
  action :create
  not_if "getent passwd #{node[:raintank_stack]['worldping-api']['user']}"
end

packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['worldping-api']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

directory node[:raintank_stack]['worldping-api']['log_dir'] do
  owner node[:raintank_stack]['worldping-api']['user']
  group node[:raintank_stack]['worldping-api']['group']
  mode "0755"
  recursive true
  action :create
end

directory node[:raintank_stack]['worldping-api']['data_dir'] do
  owner node[:raintank_stack]['worldping-api']['user']
  group node[:raintank_stack]['worldping-api']['group']
  mode "0755"
  recursive true
  action :create
end

package "worldping-api" do
  version pkg_version
  action pkg_action
  options "-o Dpkg::Options::='--force-confnew'"
end

service "worldping-api" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start ]
end

elasticsearch_host = find_haproxy || node['grafana']['elasticsearch_host']
db_host = find_haproxy || node['grafana']['db_host']
rabbitmq_host = find_haproxy || node['grafana']['rabbitmq_host']
graphite_host = find_haproxy || node['grafana']['graphite_host']

node.default[:raintank_stack]['worldping-api']['instance_id'] = node['hostname']

template "/etc/raintank/worldping-api.ini" do
  source 'worldping-api.ini.erb'
  mode '600'
  owner node[:raintank_stack]['worldping-api']['user']
  group node[:raintank_stack]['worldping-api']['group']
  variables({
    db_host: db_host,
    elasticsearch_host: elasticsearch_host,
    rabbitmq_host: rabbitmq_host,
    graphite_host: graphite_host
  })
  notifies :restart, 'service[worldping-api]', :delayed
end


