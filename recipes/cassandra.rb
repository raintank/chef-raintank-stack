include_recipe "apt"
include_recipe "java"

apt_repository 'cassandra' do
  uri 'http://debian.datastax.com/community'
  distribution 'stable'
  components [ 'main' ]
  key 'http://debian.datastax.com/debian/repo_key'
end

package 'cassandra' do
  version '2.1.9'
  action :install
end
package 'cassandra-tools' do
  version '2.1.9'
  action :install
end
package 'dsc21' do
  version '2.1.9-1'
  action :install
end

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
    :rpc_address => node['raintank_stack']['cassandra']['rpc_address'],
    :broadcast_rpc_address => node['raintank_stack']['cassandra']['broadcast_rpc_address'],
    :snitch => node['raintank_stack']['cassandra']['snitch'],
    :concurrent_reads => node['raintank_stack']['cassandra']['concurrent_reads'],
    :concurrent_writes => node['raintank_stack']['cassandra']['concurrent_writes']
  })
  notifies :restart, 'service[cassandra]'
end
