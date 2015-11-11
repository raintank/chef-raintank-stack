remote_file "/usr/bin/env-load" do
  source node['raintank_stack']['env_load_url']
  owner "root"
  group "root"
  mode '0755'
  action :create
end

bash 'load-env' do
  code 'env-load -auth "admin:admin" -orgs 40 -host http://portal.raintank.local:3000 load'
  not_if { node.attribute?('env_loaded_flag') || !node['raintank_stack']['do_env_load'] }
  notifies :create, "ruby_block[env_loaded_flag]", :immediately
  subscribes :run, 'service[grafana-server]', :delayed
end

ruby_block "env_loaded_flag" do
  block do
    node.set['env_loaded_flag'] = true
    unless Chef::Config[:solo]
      node.save
    end
  end
  action :nothing
end
