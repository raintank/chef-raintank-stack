#
# Cookbook Name:: raintank_stack
# Recipe:: dhparams
#
# Copyright (C) 2016 Raintank, Inc.
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

# create nginx directories in case it hasn't been installed yet

directory "/etc/nginx" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# separate directory resource to avoid making /etc/nginx 0700 accidentally
directory "/etc/nginx/ssl" do
  owner 'root'
  group 'root'
  mode '0700'
  action :create
end

dhparams_path = "/etc/nginx/ssl/dhparams.pem"

bash 'dhparams_create' do
  cwd '/tmp'
  code "/usr/bin/openssl dhparam -out #{dhparams_path} 2048"
  not_if { ::File.exists?(dhparams_path) }
  action :run
end
