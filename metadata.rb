name             'raintank_stack'
maintainer       'Jeremy Bingham'
maintainer_email 'jeremy@raintank.io'
license          'Apache 2.0'
description      'Installs/Configures raintank-stack'
long_description 'Installs/Configures raintank-stack'
version          '0.5.2'

depends 'apt', '~> 2.7.0'
depends 'basic_server', '~> 0.1.0'
depends 'docker', '~> 0.37.0'
depends 'rabbitmq', '~> 4.0.0'
depends 'elasticsearch', '~> 0.3.13'
depends 'redis2', '~> 0.5.1'
depends 'mysql', '~> 6.0.22'
depends 'packagecloud', '~> 0.2.0'
depends 'grafana2', '~> 0.2.5'
depends 'java', '~> 1.31.0'
depends 'nginx', '~> 2.7.6'
depends 'database', '~> 4.0.6'
depends 'mysql2_chef_gem', '~> 1.0.0'
depends	'golang', '~> 1.5.1'
depends 'mariadb', '~> 0.3.0'
depends 'nsq', '~> 1.2.3'
depends 'collectd-ng', '~> 2.0.0'
depends 'yum', '~> 3.6.0'
depends 'yum-epel', '~> 0.6.0'
depends 'yum-erlang_solutions', '~> 0.2.0'
depends 'yum-mysql-community', '~> 0.1.17'
depends 'users', '~> 1.8.2'
depends 'ark', '= 0.9.0'
depends 'users', '= 1.8.2'
depends 'ntp', '~> 1.8.6'
depends 'openssh', '~> 1.5.2'
depends 'logrotate', '~> 1.9.1'
depends 'chef-client', '~> 4.3.1'
