#
# Cookbook Name:: raintank_stack
# Recipe:: nginx
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

include_recipe 'nginx::repo'
include_recipe 'nginx'

# nginx on first boot
execute "nginx-stop-and-kill" do
  creates "/etc/nginx/firstboot"
  command "touch /etc/nginx/firstboot && service nginx stop && killall -9 nginx || echo 'not killed'"
  ignore_failure true
  notifies :start, "service[nginx]", :immediately
end

template "/etc/nginx/sites-available/grafana" do
  source "app_grafana.conf.erb"
end

nginx_site 'default' do
  enable false
end

nginx_site "grafana" do
  notifies :restart, 'service[nginx]'
end
