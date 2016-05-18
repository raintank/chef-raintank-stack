packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['tsdb']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "tsdb" do
  version pkg_version
  action pkg_action
  notifies :restart, 'service[tsdb]', :delayed
end

service "tsdb" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start]
end

nspace = {
  'key_path' => node['raintank_stack']['tsdb']['key_file'],
  'cert_path' => node['raintank_stack']['tsdb']['cert_file'],
  'common_name' => node.name
}

ssl_certificate "tsdb-#{node.name}" do
  namespace nspace
  notifies :restart, 'service[tsdb]', :delayed
  only_if { node['raintank_stack']['tsdb']['ssl'] }
end

template "/etc/raintank/tsdb.ini" do
  source 'tsdb.ini.erb'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  # notifies ....
  notifies :restart, 'service[tsdb]', :delayed
end
