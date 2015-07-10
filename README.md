# raintank-stack-cookbook

Install the entire raintank stack on one box with this cookbook, or use the individual recipes to install the different components across multiple machines.

## Supported Platforms

Currently Ubuntu 14.04. Other versions of Ubuntu, Debian, and RHEL/CentOS are coming later.

## Usage

There are multiple ways to use this cookbook.

For a complete, fully contained Litmus stack that can be used for development or trying Litmus out, you can use the Vagrantfile in this repository to bring up a vagrant instance running said full stack. You will need to install [vagrant](http://www.vagrantup.com/downloads.html), along with the vagrant-berkshelf and vagrant-omnibus plugins (`vagrant plugin install vagrant-berkshelf` and `vagrant plugin install vagrant-omnibus`), and [chefdk](https://downloads.chef.io/chef-dk/) (this makes running vagrant with berkshelf infinitely easier). If you use rbenv to manage your rubies, [rbenv-chefdk](https://github.com/docwhat/rbenv-chefdk) will make your life much easier.

After all that is installed, run:

```
$ berks install # to install the chef cookbooks in your berkshelf.
$ vagrant up    # to bring up the vagrant instance.

```

This should bring up the raintank vagrant instance up without incident, using chef-solo for provisioning. Once the VM finishes provisioning, use `vagrant ssh` to ssh into the VM and get the vagrant instance's IP address bound to eth1. Add an entry to your `/etc/hosts` file for that address pointing to `portal.raintank.local`. Once that's done, you can browse to http://portal.raintank.local and start going to town using litmus. The default recipe will also install golang for you, in case you want to make changes on the VM and recompile. The GOROOT is in `/opt/go` and is writable by the vagrant user.

An even *easier* way, if you're so inclined, is to use a prebuilt Litmus vagrant box. Once those start getting built, you'll be able to download them and be off in even shorter order. These may not be as up to date as building the vagrant instance yourself with chef-solo, though.

This cookbook can also be used to build an all-in-one litmus server on a VM somewhere as well, using either chef-solo or chef-server. Take a look at `examples/example_env.rb` for some reasonable settings to build from. The `attributes/default.rb` and `Vagrantfile` files are also useful to look at when building your nod, role, or environment attributes for this. Beyond that, it should not be a complicated process. If it does seem complicate to you, you may want to try one of the vagrant options above, or wait until such time that we are able to make cloud images or AMIs available.

The individual recipes can also be used to build the raintank stack in a cluster, with different components on different servers.

## Attributes

See the `attributes/default.rb` file for the list of attributes this cookbook uses and their defaults. The defaults are sane, but there a few settings set in the Vagrantfile that are very important for running the all-in-one stack. The most important settings for all in one are `node[:raintank_stack][:kairosdb][:replication_factor] = 1` and `node[:raintank_stack][:ping_port] = 9090`. These settings are necessary for cassandra functioning normally with only one node (the default is 3, like in a production setting) and to avoid a port collision with the collector running locally and kairosdb. If you run this in some non-vagrant setting, take a look at the Vagrantfile for some suggested settings for the all-in-one stack.

## Recipes

- default.rb: Install the entire raintank stack on one server.
- cassandra.rb: Configure cassandra. Currently used for a cluster installation, not the all-in-one installation.
- collector.rb: Installs the raintank collector.
- docker.rb and docker_compose.rb: Installs and runs cassandra in a docker container in the all-in-one install.
- graphite_api.rb: Installs the raintank fork of graphite-api.
- kairosdb.rb: Install and configure kairosdb.
- mariadb.rb: Install mariadb, configure galera, and configure the grafana databases.
- metric.rb: Install the raintank metric collector.
- mysql.rb: Formerly installed mysql. This was replaced by the mariadb recipe, but it's still hanging around for now.
- nginx.rb: Install nginx, and configure it for reverse proxying grafana.
- statsd.rb: Install the vimeo statsdaemon statsd program.

There are some other cookbooks directly used for this stack: influxdb, rabbitmq, elasticsarch, the raintank fork of the grafana2 cookbook, and (optionally) the golang cookbook. All of the dependencies are most easily obtained via berkshelf.

## License and Authors

Copyright 2015, Raintank, Inc. under the terms of Apache License, version 2.0. See the included LICENSE file for details.

Author:: Jeremy Bingham (<jeremy@raintank.io>)
