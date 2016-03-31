#
# Cookbook Name:: raintank_stack
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

# Set up a MySQL server for the raintank stack.

mysql_service 'default' do
  initial_root_password node['mysql']['server_root_password']
  socket node['mysql']['socket']
  version node['mysql']['version']
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end

# and create the grafana database if it doesn't exist. Installing grafana will
# not, by itself, create it.
mysql2_chef_gem 'default' do
  action :install
end

mysql_database node['grafana']['db_name'] do
  connection(
    :host => node['grafana']['db_host'],
    :port => node['grafana']['db_port'],
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  action :create
end

mysql_database node['raintank_stack']['worldping-api']['db_name'] do
  connection(
    :host => node['raintank_stack']['worldping-api']['db_host'],
    :port => node['raintank_stack']['worldping-api']['db_port'],
    :username => 'root',
    :password => node['mysql']['server_root_password']
  )
  action :create
end