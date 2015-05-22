#
# Cookbook Name:: raintank_stack
# Recipe:: kairosdb
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

# TODO: Ubuntu needs this at least, check on debian and others
package "libevent-dev"

include_recipe "java"

local_pkg = "#{Chef::Config[:file_cache_path]}/#{node[:raintank_stack][:kairosdb][:package]}"
remote_file local_pkg do
  source node[:raintank_stack][:kairosdb][:url]
end

dpkg_package "kairosdb" do
  source local_pkg
  action :install
end

service "kairosdb" do
  action [ :enable, :start ]
end

template "/opt/kairosdb/conf/kairosdb.properties" do
  source "kairosdb.properties.erb"
  mode "0644"
  owner "root"
  group "root"
  action :create
  variables({
    host_list: node[:raintank_stack][:kairosdb][:host_list],
    keyspace: node[:raintank_stack][:kairosdb][:keyspace],
    replication_factor: node[:raintank_stack][:kairosdb][:replication_factor],
    write_delay: node[:raintank_stack][:kairosdb][:write_delay],
    write_buffer_max_size: node[:raintank_stack][:kairosdb][:write_buffer_max_size]
  })
  notifies :restart, 'service[kairosdb]'
end
