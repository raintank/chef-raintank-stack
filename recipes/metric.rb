#
# Cookbook Name:: raintank_stack
# Recipe:: metric
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

packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['raintank_metric']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "raintank-metric" do
  version pkg_version
  action pkg_action
end

directory "/var/log/raintank" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

service "raintank-metric" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start ]
end

elasticsearch_host = find_haproxy || node['raintank_stack']['elasticsearch_host']
kairosdb_host = find_haproxy || node['raintank_stack']['kairosdb_host']
rabbitmq_host = find_haproxy || node['raintank_stack']['rabbitmq_host']
carbon_host = find_haproxy || node['raintank_stack']['carbon_host']

template "/etc/raintank/raintank-metric.conf" do
  source "raintank-metric.conf.erb"
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables({
    rabbitmq_host: rabbitmq_host,
    carbon_host: carbon_host,
    carbon_port: node['raintank_stack']['carbon_port'],
    carbon_enable: node['raintank_stack']['carbon_enable'],
    kairosdb_host: kairosdb_host,
    kairosdb_port: node['raintank_stack']['kairosdb_port'],
    kairosdb_enable: node['raintank_stack']['kairosdb_enable'],
    elasticsearch_host: elasticsearch_host,
    elasticsearch_port: node['raintank_stack']['elasticsearch_port'],
    redis_host: node['raintank_stack']['redis_host'],
    redis_port: node['raintank_stack']['redis_port'],
    redis_passwd: node['raintank_stack']['redis_passwd'],
    redis_db: node['raintank_stack']['redis_db'],
    debug_level: node['raintank_stack']['debug_level'],
    log_file: node['raintank_stack']['log_file'],
    syslog: node['raintank_stack']['syslog'],
    expvar_addr: node['raintank_stack']['expvar_addr']
  })
  notifies :restart, 'service[raintank-metric]'
end
