remote_file "/usr/bin/env-load" do
  source node['raintank_stack']['env_load_url']
  owner "root"
  group "root"
  mode '0755'
  action :create
end
