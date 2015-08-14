# general
default[:raintank_stack][:packagecloud_repo] = "raintank/raintank"

# package versions hash
default[:raintank_stack][:package_version] = {}

# kairosdb
default[:raintank_stack][:kairosdb][:version] = "0.9.4"
default[:raintank_stack][:kairosdb][:package] = "kairosdb_0.9.4-6_all.deb"
default[:raintank_stack][:kairosdb][:url] = "https://github.com/kairosdb/kairosdb/releases/download/v#{node[:raintank_stack][:kairosdb][:version]}/#{node[:raintank_stack][:kairosdb][:package]}"
default[:raintank_stack][:kairosdb][:host_list] = "localhost:9160"
default[:raintank_stack][:kairosdb][:keyspace] = "kairosdb"
default[:raintank_stack][:kairosdb][:replication_factor] = 3
default[:raintank_stack][:kairosdb][:write_delay] = 1000
default[:raintank_stack][:kairosdb][:write_buffer_max_size] = 500000

# graphite-api
default[:raintank_stack][:cache_dir] = "/tmp/graphite-api-cache"
default[:raintank_stack][:cache_type] = "filesystem"
default[:raintank_stack][:finders] = [ 'graphite_kairosdb.KairosdbFinder' ]
default[:raintank_stack][:functions] = [ 'graphite_api.functions.SeriesFunctions', 'graphite_api.functions.PieFunctions' ]
default[:raintank_stack][:cassandras] = []
default[:raintank_stack][:kairosdb_host] = "localhost"
default[:raintank_stack][:kairosdb_port] = 8080
default[:raintank_stack][:elasticsearch_host] = "localhost"
default[:raintank_stack][:elasticsearch_port] = 9200
default[:raintank_stack][:search_index] = "/var/lib/graphite/index"
default[:raintank_stack][:time_zone] = "UTC"
default[:raintank_stack][:graphite_api][:use_statsd] = false
default[:raintank_stack][:graphite_api][:statsd_host] = "localhost"
default[:raintank_stack][:graphite_api][:statsd_port] = 8125
default[:raintank_stack][:graphite_api][:log_level] = "INFO"

# collector
default[:raintank_stack][:collector_config] = "/etc/raintank/collector/config.json"
default[:raintank_stack][:collector_name] = "PublicTest"
default[:raintank_stack][:num_cpus] = nil
default[:raintank_stack][:server_url] = "http://localhost:3000"
default[:raintank_stack][:api_key] = "REPLACE_ME"
default[:raintank_stack][:ping_port] = 8080

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

# database related
default[:raintank_stack][:create_database] = true
default[:raintank_stack][:create_replication_user] = false
default[:mariadb][:galera][:cluster_name] = "galera_raintank"
default[:mariadb][:galera][:wsrep_cluster_address] = "gcomm://"
default[:mariadb][:galera][:wsrep_sst_method] = "xtrabackup"
override['mariadb']['galera']['cluster_search_query'] = "tags:mariadb AND chef_environment:#{node.environment} AND mariadb_galera_cluster_name:#{node['mariadb']['galera']['cluster_name']}"

# nginx
default[:raintank_stack][:grafana_backend] = "localhost:3000"
default[:raintank_stack][:grafana_domain] = node[:grafana][:domain]
default[:raintank_stack][:grafana_root] = "/usr/share/grafana/public"
default[:raintank_stack][:nginx][:use_ssl] = false
default[:raintank_stack][:nginx][:ssl_cert_file] = "/etc/nginx/ssl/grafana.crt"
default[:raintank_stack][:nginx][:ssl_key_file] = "/etc/nginx/ssl/grafana.key"
default[:raintank_stack][:nginx][:ssl_data_bag] = node[:raintank_stack][:grafana_domain]

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

# cassandra
default[:raintank_stack][:cassandra][:cluster_name] = "Test Cluster"
default[:raintank_stack][:cassandra][:num_tokens] = 256
default[:raintank_stack][:cassandra][:seeds] = []
default[:raintank_stack][:cassandra][:listen_interface] = "eth0"
default[:raintank_stack][:cassandra][:rpc_address] = "0.0.0.0"
default[:raintank_stack][:cassandra][:broadcast_rpc_address] = node.ipaddress
default[:raintank_stack][:cassandra][:snitch] = "SimpleSnitch"
default[:raintank_stack][:cassandra][:concurrent_reads] = 8 * node.cpu.total
default[:raintank_stack][:cassandra][:concurrent_writes] = 8 * node.cpu.total

# influxdb
override['influxdb']['version'] = "0.8.8"

default[:java][:install_flavor] = "oracle"
default[:java][:jdk_version] = "8"
default[:java][:oracle][:accept_oracle_download_terms] = true
default[:rabbitmq][:enabled_plugins] = [ 'rabbitmq_consistent_hash_exchange', 'rabbitmq_management' ]
default[:go][:version] = "1.4.2"
