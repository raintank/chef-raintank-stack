# general
default[:raintank_stack][:packagecloud_repo] = "raintank/raintank"
default[:raintank_stack][:haproxy_search] = "tags:haproxy AND chef_environment:#{node.chef_environment}"
default[:raintank_stack][:nsqd_search] = "tags:nsqd AND chef_environment:#{node.chef_environment}"
default[:raintank_stack][:cassandra_search] = "tags:cassandra AND chef_environment:#{node.chef_environment}"

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
default[:raintank_stack][:finders] = [ 'graphite_raintank.RaintankFinder' ]
default[:raintank_stack][:functions] = [ 'graphite_api.functions.SeriesFunctions', 'graphite_api.functions.PieFunctions' ]
default[:raintank_stack][:cassandras] = []
default[:raintank_stack][:tank_host] = "localhost"
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
default[:raintank_stack][:graphite_api][:log_dir] = "/var/log/graphite"
# avoid conflicts between the new and old graphite packages
default[:raintank_stack][:graphite_tank][:use_statsd] = false
default[:raintank_stack][:graphite_tank][:statsd_host] = "localhost"
default[:raintank_stack][:graphite_tank][:statsd_port] = 8125
default[:raintank_stack][:graphite_tank][:log_level] = "INFO"
default[:raintank_stack][:graphite_tank][:log_dir] = "/var/log/graphite"

# collector
default[:raintank_stack][:collector_config] = "/etc/raintank/collector/config.json"
default[:raintank_stack][:collector_name] = "PublicTest"
default[:raintank_stack][:num_cpus] = nil
default[:raintank_stack][:server_url] = "http://localhost:3000"
default[:raintank_stack][:api_key] = "REPLACE_ME"
default[:raintank_stack][:ping_port] = 8080
default[:raintank_stack][:nice_level] = 0

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
default[:mariadb][:innodb][:options][:innodb_flush_log_at_trx_commit] = 0
override['mariadb']['galera']['cluster_search_query'] = "tags:mariadb AND chef_environment:#{node.environment} AND mariadb_galera_cluster_name:#{node['mariadb']['galera']['cluster_name']}"
override[:mariadb][:use_default_repository] = true

# nginx
default[:raintank_stack][:grafana_backend] = "localhost:3000"
default[:raintank_stack][:worldping_backend] = "localhost:3001"
default[:raintank_stack][:tsdb_backend] = "localhost:8081"
default[:raintank_stack][:task_server_backend] = "localhost:8082"

default[:raintank_stack][:grafana_domain] = node[:grafana][:domain]
default[:raintank_stack][:worldping_domain] = "worldping-api.raintank.io"
default[:raintank_stack][:tsdb_domain] = "tsdb.raintank.io"
default[:raintank_stack][:task_server_domain] = "task-server.raintank.io"
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
default[:raintank_stack][:env_load_url] = "https://github.com/raintank/env-load/releases/download/20151103/env-load_linux_amd64"

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

default[:java][:install_flavor] = "oracle"
default[:java][:jdk_version] = "8"
default[:java][:oracle][:accept_oracle_download_terms] = true
default[:rabbitmq][:enabled_plugins] = [ 'rabbitmq_consistent_hash_exchange', 'rabbitmq_management' ]
default[:go][:version] = "1.4.2"
default[:elasticsearch][:version] = "1.4.4"
default[:elasticsearch][:filename] = "elasticsearch-1.4.4.tar.gz"
default[:elasticsearch][:download_url] = "http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.tar.gz"

# nsq_* tools
default[:raintank_stack][:nsq_tools][:base][:max_in_flight] = 200
default[:raintank_stack][:nsq_tools][:base][:num_msg] = 0
default[:raintank_stack][:nsq_tools][:base][:nsqd_addr] = []
default[:raintank_stack][:nsq_tools][:base][:statsd_addr] = "localhost:8125"
default[:raintank_stack][:nsq_tools][:base][:statsd_type] = "datadog"
default[:raintank_stack][:nsq_tools][:base][:elastic_addr] = "localhost:9200"
default[:raintank_stack][:nsq_tools][:base][:redis_addr] = "localhost:6379"
default[:raintank_stack][:nsq_tools][:base][:kairos_addr] = "localhost:8080"


## probe_events_to_elasticsearch
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:channel] = "elasticsearch"
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:topic] = "probe_events"
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:max_in_flight] = node[:raintank_stack][:nsq_tools][:base][:max_in_flight]
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:num_msg] = node[:raintank_stack][:nsq_tools][:base][:num_msg]
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:nsqd_addr] = node[:raintank_stack][:nsq_tools][:base][:nsqd_addr]
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:statsd_addr] = node[:raintank_stack][:nsq_tools][:base][:statsd_addr]
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:statsd_type] = node[:raintank_stack][:nsq_tools][:base][:statsd_type]
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:elastic_addr] = node[:raintank_stack][:nsq_tools][:base][:elastic_addr]
default[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:listen] = ":36062"

## metric_tank
default[:raintank_stack][:metric_tank][:instance] = "default"
default[:raintank_stack][:metric_tank][:channel] = "tank"
default[:raintank_stack][:metric_tank][:topic] = "metrics"
default[:raintank_stack][:metric_tank][:listen] = ":18763"
default[:raintank_stack][:metric_tank][:primary_node] = "true"
default[:raintank_stack][:metric_tank][:topic_notify_persist] = "metricpersist"
default[:raintank_stack][:metric_tank][:warm_up_period] = "1h"
default[:raintank_stack][:metric_tank][:ttl] = "35d"
default[:raintank_stack][:metric_tank][:chunkspan] = "30min"
default[:raintank_stack][:metric_tank][:numchunks] = 7
default[:raintank_stack][:metric_tank][:concurrency] = 10
default[:raintank_stack][:metric_tank][:cassandra_write_concurrency] = 10
default[:raintank_stack][:metric_tank][:cassandra_write_queue_size] = 100000
default[:raintank_stack][:metric_tank][:gc_interval] = "30min"
default[:raintank_stack][:metric_tank][:chunk_max_stale] = "1h"
default[:raintank_stack][:metric_tank][:metric_max_stale] = "6h"
default[:raintank_stack][:metric_tank][:log_level] = 2
default[:raintank_stack][:metric_tank][:max_in_flight] = node[:raintank_stack][:nsq_tools][:base][:max_in_flight]
default[:raintank_stack][:metric_tank][:num_msg] = node[:raintank_stack][:nsq_tools][:base][:num_msg]
default[:raintank_stack][:metric_tank][:statsd_addr] = node[:raintank_stack][:nsq_tools][:base][:statsd_addr]
default[:raintank_stack][:metric_tank][:statsd_type] = node[:raintank_stack][:nsq_tools][:base][:statsd_type]
default[:raintank_stack][:metric_tank][:agg_settings] = "10min:6h:2:38d:false,2h:6h:2:120d:false"
default[:raintank_stack][:metric_tank][:index_name] = "metric"
default[:raintank_stack][:metric_tank][:redis_db] = 0
default[:raintank_stack][:metric_tank][:elastic_addr] = node[:raintank_stack][:nsq_tools][:base][:elastic_addr]
default[:raintank_stack][:metric_tank][:redis_addr] = node[:raintank_stack][:nsq_tools][:base][:redis_addr]
default[:raintank_stack][:metric_tank][:es_warmup_percent] = 1
default[:raintank_stack][:metric_tank][:cassandra_timeout] = 1000
default[:raintank_stack][:metric_tank][:proftrigger][:heap_thresh] = 20000000
default[:raintank_stack][:metric_tank][:proftrigger][:freq] = "1s"
default[:raintank_stack][:metric_tank][:proftrigger][:path] = "/var/lib/metric-tank/prof"


############ Worldping-api 

### INSTALL ###
default[:raintank_stack]['worldping-api']['user'] = 'grafana'
default[:raintank_stack]['worldping-api']['group'] = 'grafana'

default[:raintank_stack]['worldping-api']['instance_id'] = 'default'

### PATHS ###
default[:raintank_stack]['worldping-api']['log_dir'] = '/var/log/grafana'
default[:raintank_stack]['worldping-api']['data_dir'] = '/var/lib/grafana'
default[:raintank_stack]['worldping-api']['static_root'] = 'public'

### SERVER ###
default[:raintank_stack]['worldping-api']['port'] = '3000'
default[:raintank_stack]['worldping-api']['protocol'] = 'http'
default[:raintank_stack]['worldping-api']['domain'] = node[:raintank_stack][:worldping_domain]
default[:raintank_stack]['worldping-api']['app_mode'] = 'production'
default[:raintank_stack]['worldping-api']['root_url'] = '%(protocol)s://%(domain)s:%(http_port)s/'
default[:raintank_stack]['worldping-api']['router_logging'] = false
default[:raintank_stack]['worldping-api']['enable_gzip'] = false
default[:raintank_stack]['worldping-api']['admin_key'] = 'changeme'

### DB ###
default[:raintank_stack]['worldping-api']['db_type'] = 'sqlite3' # Either mysql, postgres, or sqlite3
default[:raintank_stack]['worldping-api']['db_file'] = 'grafana.db'
default[:raintank_stack]['worldping-api']['db_name'] = 'grafana'
default[:raintank_stack]['worldping-api']['db_host'] = 'localhost'
default[:raintank_stack]['worldping-api']['db_port'] = 3306 # ip/hostname:port, Only for mysql/postgres
default[:raintank_stack]['worldping-api']['db_user'] = 'grafana_user' # Only for mysql/postgres
default[:raintank_stack]['worldping-api']['db_password'] = 'SECRET'   # Only for mysql/postgres

### SMTP ###
default[:raintank_stack]['worldping-api']['smtp']['enabled'] = false
default[:raintank_stack]['worldping-api']['smtp']['host'] = ''
default[:raintank_stack]['worldping-api']['smtp']['user'] = ''
default[:raintank_stack]['worldping-api']['smtp']['password'] = ''
default[:raintank_stack]['worldping-api']['smtp']['cert_file'] = ''
default[:raintank_stack]['worldping-api']['smtp']['key_file'] = ''
default[:raintank_stack]['worldping-api']['smtp']['from_address'] = 'admin@grafana.localhost'

### EMAIL ###
default[:raintank_stack]['worldping-api']['email']['welcome_email'] = false
default[:raintank_stack]['worldping-api']['email']['templates_pattern'] = 'emails/*.html'

### LOGGING ###
default[:raintank_stack]['worldping-api']['log_level'] = 'Info' # Either "Trace", "Debug", "Info", "Warn", "Error", "Critical"
default[:raintank_stack]['worldping-api']['log_level_console' ] = node[:raintank_stack]['worldping-api']['log_level']
default[:raintank_stack]['worldping-api']['log_level_file' ] = node[:raintank_stack]['worldping-api']['log_level']
default[:raintank_stack]['worldping-api']['log_mode'] = "console"

### EVENT PUBLISHING
default[:raintank_stack]['worldping-api']['event_publish'] = true
default[:raintank_stack]['worldping-api']['rabbitmq_host'] = 'localhost'
default[:raintank_stack]['worldping-api']['event_exchange'] = 'grafana_events'

### RAINTANK ###
default[:raintank_stack]['worldping-api']['raintank'] = true
default[:raintank_stack]['worldping-api']['graphite_host'] = 'localhost'
default[:raintank_stack]['worldping-api']['graphite_port'] = 8888
default[:raintank_stack]['worldping-api']['elasticsearch_host'] = 'localhost'

default[:raintank_stack]['worldping-api']['haproxy_search'] = "tags:haproxy AND chef_environment:#{node.chef_environment}"

### TELEMETRY
default[:raintank_stack]['worldping-api']['use_statsd'] = false
default[:raintank_stack]['worldping-api']['statsd_addr'] = "localhost:8125"
default[:raintank_stack]['worldping-api']['statsd_type'] = "standard"

### PROFILING
default[:raintank_stack]['worldping-api']['use_profiling'] = false
default[:raintank_stack]['worldping-api']['profile_heap_mb'] = 4000
default[:raintank_stack]['worldping-api']['profile_heap_dir'] = '/tmp/worldping-api-profile'
default[:raintank_stack]['worldping-api']['profile_heap_wait'] = 3600

### ALERTING
default[:raintank_stack]['worldping-api']['alerting']['enabled'] = false
default[:raintank_stack]['worldping-api']['alerting']['handler'] = "amqp"
default[:raintank_stack]['worldping-api']['alerting']['queue_ticks_size'] = 20
default[:raintank_stack]['worldping-api']['alerting']['queue_jobs_size'] = 1000
default[:raintank_stack]['worldping-api']['alerting']['pre_amqp_jobs_size'] = 1000
default[:raintank_stack]['worldping-api']['alerting']['executor_lru_size'] = 10000
default[:raintank_stack]['worldping-api']['alerting']['enable_scheduler'] = false
default[:raintank_stack]['worldping-api']['alerting']['executors'] = 10
default[:raintank_stack]['worldping-api']['alerting']['individual_alerts'] = false

### QUOTAS
default[:raintank_stack]['worldping-api']['quota']['enabled'] = true
default[:raintank_stack]['worldping-api']['quota']['org_endpoint'] = 10
default[:raintank_stack]['worldping-api']['quota']['org_collector'] = 10
default[:raintank_stack]['worldping-api']['quota']['global_endpoint'] = -1
default[:raintank_stack]['worldping-api']['quota']['global_collector'] = -1


## task_server
default[:raintank_stack]['task_server']['log_level'] = 2
default[:raintank_stack]['task_server']['addr'] = ":8082"
default[:raintank_stack]['task_server']['db_host'] = "localhost"
default[:raintank_stack]['task_server']['db_port'] = 3306
default[:raintank_stack]['task_server']['db_name'] = "task_server"
default[:raintank_stack]['task_server']['db_user'] = "task_server"
default[:raintank_stack]['task_server']['db_password'] = "secret"
default[:raintank_stack]['task_server']['stats_enabled'] = false
default[:raintank_stack]['task_server']['statsd_addr'] = "localhost:8125"
default[:raintank_stack]['task_server']['statsd_type'] = "standard"
default[:raintank_stack]['task_server']['admin_key'] = "changeme"
default[:raintank_stack]['task_server']['exchange'] = "events"
default[:raintank_stack]['task_server']['rabbitmq_url'] = "amqp://guest:guest@localhost:5672/"

## task_agent
default[:raintank_stack]['task_agent']['log_level'] = 2
default[:raintank_stack]['task_agent']['server_url'] = "ws://localhost:8082/api/v1"
default[:raintank_stack]['task_agent']['tsdb_url'] = "http://localhost:8081/"
default[:raintank_stack]['task_agent']['snap_url'] = "http://localhost:8181/"
default[:raintank_stack]['task_agent']['stats_enabled'] = false
default[:raintank_stack]['task_agent']['statsd_addr'] = "localhost:8125"
default[:raintank_stack]['task_agent']['statsd_type'] = "standard"
default[:raintank_stack]['task_agent']['api_key'] = node[:raintank_stack]['task-server']['admin_key']
default[:raintank_stack]['task_agent']['node_name'] = node['hostname']

#tsdb
default[:raintank_stack]['tsdb']['log_level'] = 2
default[:raintank_stack]['tsdb']['addr'] = ":8081"
default[:raintank_stack]['tsdb']['stats_enabled'] = false
default[:raintank_stack]['tsdb']['statsd_addr'] = "localhost:8125"
default[:raintank_stack]['tsdb']['statsd_type'] = "standard"
default[:raintank_stack]['tsdb']['admin_key'] = node[:raintank_stack]['task-server']['api_key']
default[:raintank_stack]['tsdb']['nsqd_addr'] = "localhost:4150"
default[:raintank_stack]['tsdb']['metric_topic'] = node[:raintank_stack][:metric_tank][:topic]
default[:raintank_stack]['tsdb']['publish_metrics'] = true
default[:raintank_stack]['tsdb']['event_topic'] = node[:raintank_stack][:nsq_tools][:probe_events_to_elasticsearch][:topic]
default[:raintank_stack]['tsdb']['publish_events'] = true
default[:raintank_stack]['tsdb']['graphite_url'] = "http://localhost:8888/"
default[:raintank_stack]['tsdb']['worldping_url'] = "https://worldping-api.raintank.io/"
default[:raintank_stack]['tsdb']['elasticsearch_url'] = "http://localhost:9200/"
default[:raintank_stack]['tsdb']['es_index'] = "events"
