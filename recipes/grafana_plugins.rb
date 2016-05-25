# check if the plugins are installed

inst = `/usr/sbin/grafana-cli plugins ls`
if $?.exitstatus != 0 
  raise "grafana-cli failed with exit status #{$?.exitstatus}, and output #{inst}"
end

do_restart = false

node['raintank_stack']['grafana_plugins'].each do |p|
  if inst !~ /#{p}/
    output = `/usr/sbin/grafana-cli plugins install #{p}`
    if $?.exitstatus != 0 
      raise "grafana-cli failed with exit status #{$?.exitstatus}, and output #{inst} while trying to install #{p}"
    end
    
    do_restart = true
  end
end

upgrades = `/usr/sbin/grafana-cli plugins update-all`
if $?.exitstatus != 0 
  raise "grafana-cli failed with exit status #{$?.exitstatus}, and output #{inst} trying to upgrade all plugins"
end

if upgrades =~ /Updating/
  do_restart = true
end

service 'grafana-server' do
  action :restart
  only_if { do_restart }
end
