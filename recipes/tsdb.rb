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

template "/etc/raintank/tsdb.ini" do
  source 'tsdb.ini.erb'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  # notifies ....
  notifies :restart, 'service[tsdb]', :delayed
end
