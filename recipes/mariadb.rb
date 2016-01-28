#
# Cookbook Name:: mariadb
# Recipe:: mysql
#
# Copyright (C) 2015 Jeremy Bingham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.hostname =~ /(\d+?)/
s_id = $1 || 1
node.override[:mariadb][:replication][:server_id] = s_id.to_s
node.set[:mariadb][:mysqld][:options][:log_slave_updates] = 1

include_recipe "mariadb::galera"

# and create the grafana database if it doesn't exist. Installing grafana will
# not, by itself, create it.
package "build-essential"

mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Mariadb
  action :install
end

connection_info = { :host => "127.0.0.1",
  :port => node['grafana']['db_port'],
  :username => 'root',
  :password => node['mariadb']['server_root_password']
}

if node[:raintank_stack][:create_database]
  mysql_database node['grafana']['db_name'] do
    connection connection_info
    action :create
  end

  if !node['raintank_stack']['sst_user'].nil?
    mysql_database_user node['raintank_stack']['sst_user'] do
      connection connection_info
      password node['raintank_stack']['sst_password']
      action :create
    end
    mysql_database_user node['raintank_stack']['sst_user'] do
      connection connection_info
      password node['raintank_stack']['sst_password']
      privileges [ :reload, :"lock tables", :"replication client" ]
      action :grant
    end
  end
  if node['grafana']['db_user'] != 'root'
    mysql_database_user node['grafana']['db_user'] do
      connection connection_info
      password node['grafana']['db_password']
      action :create
    end
    mysql_database_user node['grafana']['db_user'] do
      connection connection_info
      password node['grafana']['db_password']
      database_name node['grafana']['db_name']
      host node['raintank_stack']['repl_host']
      privileges [:all]
      action :grant
    end
  end
  if !node['raintank_stack']['repl_user'].nil?
    mysql_database_user node['raintank_stack']['repl_user'] do
      connection connection_info
      password node['raintank_stack']['repl_pass']
      action :create
    end
    mysql_database_user node['raintank_stack']['repl_user'] do
      connection connection_info
      password node['raintank_stack']['repl_pass']
      privileges [ :"replication slave" ]
      host node['raintank_stack']['repl_host']
      action :grant
    end
  end
end
