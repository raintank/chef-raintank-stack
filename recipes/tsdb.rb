packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

pkg_version = node['raintank_stack']['package_version']['tsdb']
pkg_action = if pkg_version.nil?
  :upgrade
else
  :install
end

package "tsdb" do
  version pkg_version
  action pkg_action
  notifies :restart, 'service[tsdb]', :delayed
end

service "tsdb" do
  case node["platform"]
  when "ubuntu"
    if node["platform_version"].to_f >= 9.10
      provider Chef::Provider::Service::Upstart
    end
  end
  action [ :enable, :start]
end

nspace = {
  'key_path' => node['raintank_stack']['tsdb']['key_file'],
  'cert_path' => node['raintank_stack']['tsdb']['cert_file'],
  'key_dir' => "/etc/raintank",
  'cert_dir' => "/etc/raintank",
  'common_name' => node.name
}

if node['raintank_stack']['tsdb']['ssl']
  if node['raintank_stack']['tsdb']['real_ssl_cert']
    certs = Chef::EncryptedDataBagItem.load(:grafana_ssl_certs, node['raintank_stack']['tsdb']['ssl_data_bag']).to_hash
    file node['raintank_stack']['tsdb']['cert_file'] do
      owner "root"
      group "root"
      mode '0600'
      content certs['ssl_cert']
      action :create
    end
    file node['raintank_stack']['tsdb']['key_file'] do
      owner "root"
      group "root"
      mode '0600'
      content certs['ssl_key']
      action :create
    end
  else
    cert = ssl_certificate "tsdb-#{node.name}" do
      namespace nspace
      notifies :restart, 'service[tsdb]', :delayed
    end

    node.set['raintank_stack']['tsdb']['cert_file'] = cert.cert_path
    node.set['raintank_stack']['tsdb']['key_file'] = cert.key_path
  end
end

template "/etc/raintank/tsdb.ini" do
  source 'tsdb.ini.erb'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  # notifies ....
  notifies :restart, 'service[tsdb]', :delayed
end
