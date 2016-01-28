include_recipe "apt"
bash "update_raintank_apt" do
  cwd "/tmp"
  code <<-EOH
    apt-get update -o Dir::Etc::sourcelist="sources.list.d/raintank_raintank_.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" || true
    EOH
end

package "ntp"
if node.attribute?('gce')
  node.set['ntp']['servers'] = %w(metadata.google.internal)
else
  node.set['ntp']['servers'] = %w(0.pool.ntp.org)
end

unless Chef::Config[:solo]
  include_recipe "basic_server::users"
end

include_recipe "ntp"


if node["raintank_deploys"]["use_chef_client_cron"]
  include_recipe "cron"
  include_recipe "chef-client::cron"
  include_recipe "logrotate"
  logrotate_app "chef-client" do
    path "/var/log/chef-client-cron.log"
    frequency "daily"
    create "644 root root"
    rotate 7
    enable true
  end
end

template "/etc/rc.local" do
  source "rc.local.erb"
  mode "0755"
  owner "root"
  group "root"
  variables({
    :rc_local_items => node['raintank_stack']['rc_local_items']
  }) 
  action :create 
end

include_recipe "openssh"

include_recipe "raintank_stack::default"
