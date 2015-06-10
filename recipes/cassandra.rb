include_recipe "apt"
include_recipe "java"

apt_repository 'cassandra' do
  uri 'http://debian.datastax.com/community'
  distribution 'stable'
  components [ 'main' ]
  key 'http://debian.datastax.com/debian/repo_key'
end

package 'cassandra'
package 'dsc21'

service 'cassandra' do
  action [ :enable, :start ]
end

seeds = node[:raintank_stack][:cassandra][:seeds].join(",") # todo: search for
							    # appropriate nodes
template "/etc/cassandra/cassandra.yaml" do
  source "cassandra.yaml.erb"
  mode "0644"
  owner "root"
  group "root"
  action :create
  variables({
    :cluster_name => node['raintank_stack']['cassandra']['cluster_name'],
    :num_tokens => node['raintank_stack']['cassandra']['num_tokens'],
    :seeds => seeds,
    :listen_interface => node['raintank_stack']['cassandra']['listen_interface'],
    :rpc_interface => node['raintank_stack']['cassandra']['rpc_interface'],
    :snitch => node['raintank_stack']['cassandra']['snitch']
  })
  notifies :restart, 'service[cassandra]'
end
