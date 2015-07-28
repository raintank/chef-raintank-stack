#
# Cookbook Name:: raintank_stack
# Recipe:: statsd
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

# install the vimeo statsdaemon

packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

package "statsdaemon" do
  action :install
end

service "statsdaemon" do
  action [ :enable, :start ]
end

template "/etc/statsdaemon.ini" do
  source "statsdaemon.ini.erb"
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  notifies :restart, 'service[statsdaemon]'
end
