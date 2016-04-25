packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['task-agent']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "task-agent" do
  version pkg_version
  action pkg_action
  notifies :restart, 'service[task-agent]', :delayed
end

service "task-agent" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable]
end


pkg_version = node['raintank_stack']['package_version']['snap']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "snap-agent" do
  version pkg_version
  action pkg_action
  notifies :restart, 'service[snap]', :delayed
end

service "snap" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable]
end


template "/etc/raintank/task-agent.ini" do
  source 'task-agent.ini.erb'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  # notifies ....
  notifies :restart, 'service[task-agent]', :delayed
end
