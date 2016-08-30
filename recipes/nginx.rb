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

include_recipe 'raintank_stack::ssl_updates'
include_recipe 'raintank_stack::dhparams'

# create ssl cert files if we're doing that
if node['raintank_stack']['nginx']['use_ssl']
  directory "/etc/nginx/ssl" do
    owner node['nginx']['user']
    group node['nginx']['group']
    mode '0700'
    action :create
  end

  # Later: this should use chef-vault instead of encrypted data bags
  certs = Chef::EncryptedDataBagItem.load(:grafana_ssl_certs, node['raintank_stack']['nginx']['ssl_data_bag']).to_hash
  cert_file = node['raintank_stack']['nginx']['ssl_cert_file']
  cert_key = node['raintank_stack']['ssl_key_file']
  file node['raintank_stack']['nginx']['ssl_cert_file'] do
    owner node['nginx']['user']
    group node['nginx']['group']
    mode '0600'
    content certs['ssl_cert']
    action :create
  end
  file node['raintank_stack']['nginx']['ssl_key_file'] do
    owner node['nginx']['user']
    group node['nginx']['group']
    mode '0600'
    content certs['ssl_key']
    action :create
  end
end

# nginx on first boot
execute "nginx-stop-and-kill" do
  creates "/etc/nginx/firstboot"
  command "touch /etc/nginx/firstboot && service nginx stop && killall -9 nginx || echo 'not killed'"
  ignore_failure true
  notifies :start, "service[nginx]", :immediately
end

gn_source = if node['raintank_stack']['nginx']['use_ssl']
  "app_grafana_ssl.conf.erb"
else
  "app_grafana.conf.erb"
end

template "/etc/nginx/sites-available/grafana" do
  source gn_source
end

nginx_site 'default' do
  enable false
end

nginx_site "grafana" do
  notifies :restart, 'service[nginx]'
end

if !node['raintank_stack']['grafana_domain_aliases'].nil? && !node['raintank_stack']['skip_grafana_aliases']
  node['raintank_stack']['grafana_domain_aliases'].each do |site|
    ssl_cert = ssl_key = nil
    if site['use_ssl']
      redir_certs = Chef::EncryptedDataBagItem.load(:grafana_ssl_certs, site['server_name']).to_hash
      ssl_cert = site['ssl_cert_file']
      ssl_key = site['ssl_key_file']
      file ssl_cert do
        owner node['nginx']['user']
        group node['nginx']['group']
        mode '0600'
        content redir_certs['ssl_cert']
        action :create
      end
      file ssl_key do
        owner node['nginx']['user']
        group node['nginx']['group']
        mode '0600'
        content redir_certs['ssl_key']
        action :create
      end
    end
    template "/etc/nginx/sites-available/#{site['server_name']}" do
      source "app_grafana_redir.conf.erb"
      variables({
        server_name: site['server_name'],
        redir_name: node['raintank_stack']['grafana_domain'],
        use_ssl: site['use_ssl'],
        ssl_cert: ssl_cert,
        ssl_key: ssl_key
      })
    end
    nginx_site site['server_name'] do
      notifies :restart, 'service[nginx]'
    end

  end
end
