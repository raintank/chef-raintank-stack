name             'raintank_stack'
maintainer       'Jeremy Bingham'
maintainer_email 'jeremy@raintank.io'
license          'Apache 2.0'
description      'Installs/Configures raintank-stack'
long_description 'Installs/Configures raintank-stack'
version          '0.2.2'

depends 'docker', '~> 0.37.0'
depends 'rabbitmq', '~> 4.0.0'
depends 'elasticsearch', '~> 0.3.14'
depends 'redis2', '~> 0.5.1'
depends 'mysql', '~> 6.0.22'
depends 'packagecloud', '~> 0.0.17'
depends 'grafana2', '~> 0.2.0'
depends 'java', '~> 1.31.0'
depends 'nginx', '~> 2.7.6'
depends 'influxdb', '~> 0.1.4'
depends 'database', '~> 4.0.6'
depends 'mysql2_chef_gem', '~> 1.0.0'
depends	'golang', '~> 1.5.1'
depends 'mariadb', '~> 0.3.0'
depends 'nsq', '~> 1.2.0'
