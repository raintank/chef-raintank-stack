# kairosdb
default[:raintank_stack][:kairosdb][:version] = "0.9.4"
default[:raintank_stack][:kairosdb][:package] = "kairosdb_0.9.4-6_all.deb"
default[:raintank_stack][:kairosdb][:url] = "https://github.com/kairosdb/kairosdb/releases/download/v#{node[:raintank_stack][:kairosdb][:version]}/#{node[:raintank_stack][:kairosdb][:package]}"
default[:raintank_stack][:kairosdb][:host_list] = "localhost:9160"
default[:raintank_stack][:kairosdb][:keyspace] = "kairosdb"
default[:raintank_stack][:kairosdb][:replication_factor] = 1
default[:raintank_stack][:kairosdb][:write_delay] = 1000
default[:raintank_stack][:kairosdb][:write_buffer_max_size] = 500000

# graphite-api
default[:raintank_stack][:cache_dir] = "/tmp/graphite-api-cache"
default[:raintank_stack][:cache_type] = "filesystem"
default[:raintank_stack][:finders] = [ 'graphite_kairosdb.KairosdbFinder' ]
default[:raintank_stack][:functions] = [ 'graphite_api.functions.SeriesFunctions', 'graphite_api.functions.PieFunctions' ]
default[:raintank_stack][:kairosdb_host] = "localhost"
default[:raintank_stack][:kairosdb_port] = 8080
default[:raintank_stack][:elasticsearch_host] = "localhost"
default[:raintank_stack][:elasticsearch_port] = 9200
default[:raintank_stack][:search_index] = "/var/lib/graphite/index"
default[:raintank_stack][:time_zone] = "UTC"

# collector
default[:raintank_stack][:collector_config] = "/etc/raintank/collector/config.json"
default[:raintank_stack][:collector_name] = "PublicTest"
default[:raintank_stack][:num_cpus] = nil
default[:raintank_stack][:server_url] = "http://localhost:3000"
default[:raintank_stack][:api_key] = "REPLACE_ME"

# metric
default[:raintank_stack][:rabbitmq_host] = "localhost"
default[:raintank_stack][:carbon_host] = "localhost"
default[:raintank_stack][:carbon_port] = 2003
default[:raintank_stack][:carbon_enable] = false
default[:raintank_stack][:kairosdb_enable] = true
default[:raintank_stack][:redis_host] = "localhost"
default[:raintank_stack][:redis_port] = 6379
default[:raintank_stack][:debug_level] = "info"
default[:raintank_stack][:log_file] = "/var/log/raintank/metric.log"
default[:raintank_stack][:syslog] = false

# nginx
default[:raintank_stack][:grafana_backend] = "localhost:3000"
default[:raintank_stack][:grafana_domain] = node[:grafana][:domain]
default[:raintank_stack][:grafana_root] = "/usr/share/grafana/public"

# database
override[:mysql][:socket] = '/var/run/mysqld/mysqld.sock'
override[:mysql][:version] = '5.5'

# statsd
default[:raintank_stack][:statsd][:listen_addr] = ':8125'
default[:raintank_stack][:statsd][:admin_addr] = ':8126'
default[:raintank_stack][:statsd][:profile_addr] = ':6060'
default[:raintank_stack][:statsd][:graphite_addr] = '127.0.0.1:2003'
default[:raintank_stack][:statsd][:flush_interval] = 60
default[:raintank_stack][:statsd][:processes] = 4
default[:raintank_stack][:statsd][:instance] = '${HOST}'
default[:raintank_stack][:statsd][:prefix_rates] = 'stats.'
default[:raintank_stack][:statsd][:prefix_timers] = 'stats.timers.'
default[:raintank_stack][:statsd][:prefix_gauges] = 'stats.gauges.'
default[:raintank_stack][:statsd][:percentile_thresholds] = '90,75'
default[:raintank_stack][:statsd][:max_timers_per_s] = 10000

default[:java][:install_flavor] = "oracle"
default[:java][:oracle][:accept_oracle_download_terms] = true
default[:rabbitmq][:enabled_plugins] = [ 'rabbitmq_consistent_hash_exchange', 'rabbitmq_management' ]
default[:go][:version] = "1.4.2"
