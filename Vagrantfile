# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = 'portal.raintank.local'

  # Set the version of chef to install using the vagrant-omnibus plugin
  # NOTE: You will need to install the vagrant-omnibus plugin:
  #
  #   $ vagrant plugin install vagrant-omnibus
  #
  if Vagrant.has_plugin?("vagrant-omnibus")
    config.omnibus.chef_version = 'latest'
  end

  # Every Vagrant virtual environment requires a box to build off of.
  # If this value is a shorthand to a box in Vagrant Cloud then
  # config.vm.box_url doesn't need to be specified.
  config.vm.box = 'chef/ubuntu-14.04'


  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :private_network, type: 'dhcp'

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "8192"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # The path to the Berksfile to use with Vagrant Berkshelf
  # config.berkshelf.berksfile_path = "./Berksfile"

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to exclusively install and copy to Vagrant's shelf.
  # config.berkshelf.only = []

  # An array of symbols representing groups of cookbook described in the Vagrantfile
  # to skip installing and copying to Vagrant's shelf.
  # config.berkshelf.except = []

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      mysql: {
        server_root_password: 'rootpass',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass'
      },
      mariadb: {
        server_root_password: 'rootpass',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass',
	use_default_repository: true,
	mysqld: {
	  options: {
	    binlog_format: "ROW",
	    innodb_autoinc_lock_mode: 2
	  }
	},
	galera: {
	  wsrep_sst_method: 'xtrabackup-v2'
	}
      },
      grafana: {
	domain: "portal.raintank.local",
	root_url: "http://portal.raintank.local/",
	db_type: "mysql",
	db_host: "localhost",
	db_port: "3306",
	db_name: "grafana",
	db_user: "root",
	db_password: "rootpass",
	auto_assign_org: false
      },
      collectd: {
	plugins: {
	  write_graphite: {
	    config: {
	      Prefix: "testcollectd.vagrant.",
	      EscapeCharacter: "_",
	      SeparateInstances: true,
	      StoreRates: false,
	      AlwaysAppendDS: false
	    }
	  },
	  cpu: {},
	  df: {
	    config: {
	      FSType: [ "rootfs", "sysfs", "proc", "devtmpfs", "devpts", "tmpfs", "fusectl", "cgroup" ],
	      IgnoreSelected: true
	    }
	  },
	  disk: {},
	  interface: {
	    config: {
	      Interface: "lo",
	      IgnoreSelected: true
	    }
	  },
	  memory: {},
	  processes: {},
	  swap: {
	    config: {
	      ReportByDevice: false,
	      ReportBytes: true
	    }
	  },
	  users: {},
	},
	java_plugins: {
	  cassandra: {
	    config: {
	      mbeans: {
		'cassandra/classes' => {
		  ObjectName: "java.lang:type=ClassLoading",
		  InstancePrefix: "cassandra_java",
		  values: [
		    {
		      Type: "gauge",
		      InstancePrefix: "loaded_classes",
		      Table: false,
		      Attribute: "LoadedClassCount"
		    }
		  ]
		},
		'cassandra/compilation' => {
		  ObjectName: "java.lang:type=Compilation",
		  InstancePrefix: "cassandra_java",
		  values: [
		    {
		      Type: "total_time_in_ms",
		      InstancePrefix: "compilation_time",
		      Table: false,
		      Attribute: "TotalCompilationTime"
		    }
		  ]
		},
		'cassandra/metrics' => {
		  ObjectName: "org.apache.cassandra.metrics:type=ClientRequest,*",
		  InstancePrefix: "cassandra_client_request-latency",
		  values: [
		    {
		      Type: "total_time_in_ms",
		      InstanceFrom: "scope",
		      Table: false,
		      Attribute: "Mean"
		    }
		  ]
		},
		'cassandra/storage_proxy' => {
		  ObjectName: "org.apache.cassandra.db:type=StorageProxy",
		  InstancePrefix: "cassandra_activity_storage_proxy",
		  values: [
		    {
		      Type: "counter",
		      InstancePrefix: "read",
		      Table: false,
		      Attribute: "ReadOperations"
		    },
		    {
		      Type: "counter",
		      InstancePrefix: "write",
		      Table: false,
		      Attribute: "WriteOperations"
		    }
		  ]
		},
		'cassandra/memory' => {
		  ObjectName: "java.lang:type=Memory,*",
		  InstancePrefix: "cassandra_java_memory",
		  values: [
		    {
		      Type: "memory",
		      InstancePrefix: "heap-",
		      Table: true,
		      Attribute: "HeapMemoryUsage"
		    },
		    {
		      Type: "memory",
		      InstancePrefix: "nonheap-",
		      Table: true,
		      Attribute: "NonHeapMemoryUsage"
		    }
		  ]
		},
		'cassandra/memory_pool' => {
		  ObjectName: "java.lang:type=MemoryPool,*",
		  InstancePrefix: "cassandra_java_memory_pool-",
		  InstanceFrom: "name",
		  values: [
		    {
		      Type: "memory",
		      Table: true,
		      Attribute: "Usage"
		    }
		  ]
		},
		'cassandra/garbage_collector' => {
		  ObjectName: "java.lang:type=GarbageCollector,*",
		  InstancePrefix: "cassandra_java_gc-",
		  InstanceFrom: "name",
		  values: [
		    {
		      Type: "invocations",
		      Table: false,
		      Attribute: "CollectionCount"
		    },
		    {
		      Type: "total_time_in_ms",
		      InstancePrefix: "collection_time",
		      Table: false,
		      Attribute: "CollectionTime"
		    }
		  ]
		},
		'cassandra/concurrent' => {
		  ObjectName: "org.apache.cassandra.internal:type=*",
		  InstancePrefix: "cassandra_activity_internal",
		  values: [
		    {
		      Type: "counter",
		      InstancePrefix: "tasks-",
		      InstanceFrom: "type",
		      Attribute: "CompletedTasks"
		    }
		  ]
		},
		'cassandra/request' => {
		  ObjectName: "org.apache.cassandra.request:type=*",
		  InstancePrefix: "cassandra_activity_request",
		  values: [
		    {
		      Type: "counter",
		      InstancePrefix: "tasks-",
		      InstanceFrom: "type",
		      Attribute: "CompletedTasks"
		    }
		  ]
		},
		'cassandra/compaction' => {
		  ObjectName: "org.apache.cassandra.db:type=CompactionManager",
		  InstancePrefix: "cassandra_compaction",
		  values: [
		    {
		      Type: "gauge",
		      InstancePrefix: "pending",
		      Attribute: "PendingTasks"
		    }
		  ]
		},
		'cassandra/cifstats' => {
		  ObjectName: "org.apache.cassandra.db:type=ColumnFamilies,*",
		  InstanceFrom: "keyspace",
		  InstancePrefix: "cassandra_columnfamilies_stats-",
		  values: [
		    {
		      Type: "counter",
		      InstancePrefix: "livereadcount-",
		      InstanceFrom: "columnfamily",
		      Attribute: "ReadCount"
		    },
		    {
		      Type: "counter",
		      InstancePrefix: "livereadlatency-",
		      InstanceFrom: "columnfamily",
		      Attribute: "TotalReadLatencyMicros"
		    },
		    {
		      Type: "counter",
		      InstancePrefix: "livewritecount-",
		      InstanceFrom: "columnfamily",
		      Attribute: "WriteCount"
		    },
		    {
		      Type: "counter",
		      InstancePrefix: "livewrtelatency-",
		      InstanceFrom: "columnfamily",
		      Attribute: "TotalWriteLatencyMicros"
		    },
		    {
		      Type: "gauge",
		      InstancePrefix: "live_sstable_count-",
		      InstanceFrom: "columnfamily",
		      Attribute: "LiveSSTableCount"
		    },
		    {
		      Type: "gauge",
		      InstancePrefix: "total_disk_space_used-",
		      InstanceFrom: "columnfamily",
		      Attribute: "TotalDiskSpaceUsed"
		    }
		  ]
		}
	      },
	      connection: {
		Host: "portal.raintank.io",
		ServiceURL: "service:jmx:rmi:///jndi/rmi://localhost:7199/jmxrmi",
		Collect: [ "cassandra/storage_proxy", "cassandra/classes", "cassandra/compilation", "cassandra/memory", "cassandra/memory_pool", "cassandra/garbage_collector", "cassandra/metrics", "cassandra/concurrent", "cassandra/cfstats", "cassandra/request", "cassandra/compaction" ]
	      }
	    }
	  }
	},
	graphite_ipaddress: "147.75.194.39"
      },
      raintank_stack: {
	api_key: "eyJrIjoiWmZLTktlNHJ0UFFBdWtVdkRyemNiMjZPNFpralA1M3kiLCJuIjoiY29sbGVjdG9yIiwiaWQiOjF9",
	ping_port: 9090,
	kairosdb: {
	  replication_factor: 1
	},
	nginx: {
	  use_ssl: false
	},
	cassandra: {
	  concurrent_reads: 32,
	  concurrent_writes: 32
	}
      },
      cassandra: {
	listen_interface: "eth0",
	'seeds' => [ "127.0.0.1" ]
      },
      influxdb: {
	version: "0.8.8"
      },
      go: {
	version: "1.4.2"
      },
      nsq: {
	version: "0.3.5",
	go_version: "go1.4.2",
	nsqd: {
	  statsd_interval: "10s",
	  e2e_processing_latency_window_time: "10s",
	  e2e_processing_latency_percentile: "0.90,0.99",
	  mem_queue_size: 0,
	  sync_every: 4,
	  max_msg_size: "10024768",
	  lookupd_tcp_address: [],
	  msg_timeout: "60s"
	},
	nsqadmin: {
	  lookupd_http_address: [],
	  nsqd_http_address: [],
	  statsd_interval: "10s"
	}
      }
    }

    #chef.encrypted_data_bag_secret_key_path = "~/.chef/encrypted_data_bag_secret"
    #chef.data_bags_path = "../../data_bags"

    chef.run_list = [
      'recipe[raintank_stack::default]',
      'recipe[raintank_stack::env_load]'
    ]
  end
end
