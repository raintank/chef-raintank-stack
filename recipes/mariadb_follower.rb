#
# Cookbook Name:: mariadb
# Recipe:: mysql
#
# Copyright (C) 2015 Raintank, Inc.
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
s_id = $1 || "1"
s_id = s_id.to_i
s_id += 100
node.override[:mariadb][:replication][:server_id] = s_id.to_s
node.set[:mariadb][:mysqld][:options][:log_slave_updates] = 1

include_recipe "mariadb::server"
package "percona-xtrabackup" do
  action :install
end

# and create the grafana database if it doesn't exist. Installing grafana will
# not, by itself, create it.
mysql2_chef_gem 'default' do
  provider Chef::Provider::Mysql2ChefGem::Mariadb
  action :install
end
