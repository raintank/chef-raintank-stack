#
# Cookbook Name:: raintank_stack
# Recipe:: graphite_raintank
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

packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['graphite_raintank']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "graphite-raintank" do
  version pkg_version
  action pkg_action
end

group "graphite" do
  members "graphite"
  system
  action :create
end

directory "/var/lib/graphite" do
  owner "graphite"
  group "graphite"
  mode "0755"
  recursive true
  action :create
end

directory node['raintank_stack']['graphite_tank']['log_dir'] do
  owner "graphite"
  group "graphite"
  mode "0755"
  recursive true
  action :create
end

service "graphite-raintank" do
  action [ :enable, :start ]
end

elasticsearch_host = find_haproxy || node['raintank_stack']['elasticsearch_host']
tank_host = find_haproxy || node['raintank_stack']['tank_host']

template "/etc/graphite-raintank.yaml" do
  source 'graphite-raintank.yaml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  variables({
    cache_dir: node['raintank_stack']['cache_dir'],
    cache_type:	node['raintank_stack']['cache_type'],
    finders: node['raintank_stack']['finders'],
    functions: node['raintank_stack']['functions'],
    cassandras: node['raintank_stack']['cassandras'],
    tank_host: tank_host,
    tank_port: node['raintank_stack']['metric_tank']['listen'].sub(/^:/, ""),
    elasticsearch_host: elasticsearch_host,
    elasticsearch_port: node['raintank_stack']['elasticsearch_port'],
    search_index: node['raintank_stack']['search_index'],
    time_zone: node['raintank_stack']['time_zone'],
    use_statsd: node['raintank_stack']['graphite_tank']['use_statsd'],
    statsd_host: node['raintank_stack']['graphite_tank']['statsd_host'],
    statsd_port: node['raintank_stack']['graphite_tank']['statsd_port'],
    log_level: node['raintank_stack']['graphite_tank']['log_level'],
    log_dir: node['raintank_stack']['graphite_tank']['log_dir'],
    index_name: node['raintank_stack']['nsq_tools']['metrics_to_elasticsearch']['index_name']
  })
  notifies :restart, 'service[graphite-raintank]'
end


