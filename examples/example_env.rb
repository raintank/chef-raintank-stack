name "example_env"
description "Example settings for the raintank Litmus environment."
default_attributes(
  "grafana" => {
    "db_host" => "127.0.0.1",
    "db_user" => "grafana",
    "db_password" => "goober",
    "db_port" => "3306",
    "db_type" => "mysql",
    "domain" => "my.litmus.local",
    "rabbitmq_host" => "127.0.0.1",
    "graphite_host" => "127.0.0.1",
    "elasticsearch_host" => "127.0.0.1",
    "anon_enabled" => false,
    "root_url" => "http://my.litmus.local",
    "session_type" => "memory",
    "cookie_secure" => "true",
    "use_profiling" => false,
    "profile_heap_dir" => "/var/grafana-profile",
    "use_statsd" => false
  },
  "raintank_stack" => {
    "create_database" => false,
    "sst_user" => "sst",
    "sst_password" => "hermfermnerm",
    "kairosdb_host" => "127.0.0.1",
    "elasticsearch_host" => "127.0.0.1",
    "rabbitmq_host" => "127.0.0.1",
    "redis_host" => "127.0.0.1",
    "carbon_host" => "127.0.0.1",
    "server_url" => "http://my.litmus.local",
    "api_key" => "REPLACE_ME",
    "cassandra" => {
      "listen_interface" => "eth0",
      "snitch" => "SimpleSnitch",
      "seeds" => [ "127.0.0.1" ]
    },
    "nginx" => {
      "use_ssl" => false
    },
    "statsd" => {
      "graphite_addr" => "127.0.0.1:2003"
    },
    "graphite_api" => {
      "use_statsd" => true
    }
  },
  "rabbitmq" => {
    "loopback_users" => [],
    "cluster" => true,
    "erlang_cookie" => "rtrmqcookie",
    "cluster_disk_nodes" => [
      "rabbit@rabbitmq-1",
      "rabbit@rabbitmq-2"
    ],
    "clustering" => {
      "use_auto_clustering" => true,
      "cluster_name" => "litmus-rmq-cluster",
      "cluster_nodes" => [
      ]
    }
  },
  "elasticsearch" => {
    "cluster" => "elasticsearch_dev_cluster",
    "discovery" => {
      "search_query" => "tags:elasticsearch AND chef_environment:development_gce",
      "node_attribute" => "cloud_v2.local_ipv4"
    }
  }
)
override_attributes(
  "mariadb" => {
    "mysqld" => {
      "bind_address" => "0.0.0.0" # only a valid assumption if we don't listen
				  # on a public address at all
    },
    "server_root_password" => "moomer",
    "debian" => {
      "password" => "sosecret"
    },
    "innodb" => { # more tuning, later. Holding off until I know more what
		  # innodb settings work well with galera
      "buffer_pool_size" => "1024M"
    },
    "galera" => {
      "cluster_name" => "galera_litmus_cluster",
      "wsrep_sst_auth" => '"sst:hermfermnerm"'
    }
  },
  "influxdb" => {
    "version" => "0.8.8"
  }
)
