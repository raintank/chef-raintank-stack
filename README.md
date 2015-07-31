# raintank-stack-cookbook

Install the entire raintank stack on one box with this cookbook, or use the individual recipes to install the different components across multiple machines. 

These cookbooks can be utilized in a variety of ways.

## Supported platforms

We currently support only Ubuntu 14.04. Other versions of Ubuntu, Debian, and RHEL/CentOS are coming later. 



## Recipes

The entire stack is comprised of the following cookbooks, which are all included in this repository.

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

## Usage

There are multiple ways to use this repo. This document will initially focus on making it easy to set up a local test or development environment of the entire stack.

### 1) Using chef to set up a local dev environment (with Vagrant)

You can utilize Vagrant to bring up a seamless single-server instance of the entire stack by utilizing the included Vagrantfile in this repository. This stack includes a single collector called PublicTest.

Before you get started, you will need to configure your workstation to work with Vagrant, Chef, and Git. Luckily, these tools are well supported across a wide variety of platforms (Linux, Mac, Windows).

#### a) Install Vagrant, and set up a provider

If you don't already have Vagrant installed, you'll need to install it: 

- Get Vagrant - http://www.vagrantup.com/downloads.html

You'll also need to set up a virtualization platform for Vagrant to work with. The easiest is VirtualBox, which Vagrant has default support for:

- Get VirtualBox - https://www.virtualbox.org/wiki/Downloads

#### b) Download the Chef Development kit, and install necessary  plugins
 
The stack utilizes chef as well as the Vagrant berkshelf and Vagrant omnibus plugins.

- Get the Chef DK - http://downloads.chef.io/chef-dk

Install the plugins by typing:

```
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-omnibus
```

If you do install chefdk and you use rbenv to manage your rubies, we highly recommend checking out https://github.com/docwhat/rbenv-chefdk. This rbenv plugin lets you easily switch to using the ruby embedded in chefdk, which makes certain tasks a lot easier.

#### c) Bring up your development environment

From the directory containing this repo, install the cookbooks and bring up your environment by typing:

```
berks install # install the chef cookbooks in your berkshelf.
vagrant up    # bring up the vagrant instance of the whole stack
```

#### d) Cross fingers, and wait

The process should bootstrap your Vagrant instance, and install and configure the entire raintank stack by utilizing chef-solo. Depending on the speed of your CPU and network connection, the process should take about 10-30 minutes.

#### e) SSH into your development environment

You can see all the instances running under Vagrant by running:

```
vagrant global-status
```

You should see your instance running. Note the instance-id (first column). Go ahead and SSH into by running:

```
vagrant ssh instance-id
```

You should be able to log-in and the VM should be healthy. You can discover the IP address of your new instance by running:

```
ifconfig eth1
```

#### f) Verify the stack is up

In a browser try to bring up `http://IP`

You should see a Litmus log-in screen. The default username and password is `admin/admin`

You should add `portal.raintank.local` to your /etc/hosts or equivalent, and use this URL for testing.

Make sure you can add an endpoint, and see datapoints in a dashboard.

#### g) Enjoy

The default recipe will also install golang for you, in case you want to make changes on the live VM and recompile. 

The GOROOT is in `/opt/go` and is writable by the vagrant user.

{Coming, how to save direcltly on to the VM from your workstation easily, etc}

### Using chef to deploy to the public cloud

{Coming}

### Using chef for clustered environments

{Coming}

====

{COMING SOON}

An even *easier* way, if you're so inclined, is to use a prebuilt Litmus vagrant box. Once those start getting built, you'll be able to download them and be off in even shorter order. These may not be as up to date as building the vagrant instance yourself with chef-solo, though.

This cookbook can also be used to build an all-in-one litmus server on a VM somewhere, using either chef-solo or chef-server. Take a look at `examples/example_env.rb` for some reasonable settings to build from. The `attributes/default.rb` and `Vagrantfile` files are also useful to look at when building your nod, role, or environment attributes for this. Beyond that, it should not be a complicated process. If it does seem complicated to you, you may want to try one of the vagrant options above, or wait until such time that we are able to make cloud images or AMIs available.

The individual recipes can also be used to build the raintank stack in a cluster, with different components on different servers.

## Attributes

See the `attributes/default.rb` file for the list of attributes this cookbook uses and their defaults. The defaults are sane, but there a few settings set in the Vagrantfile that are very important for running the all-in-one stack. The most important settings for all in one are `node[:raintank_stack][:kairosdb][:replication_factor] = 1` and `node[:raintank_stack][:ping_port] = 9090`. These settings are necessary for cassandra functioning normally with only one node (the default is 3, like in a production setting) and to avoid a port collision with the collector running locally and kairosdb. If you run this in some non-vagrant setting, take a look at the Vagrantfile for some suggested settings for the all-in-one stack.

## License and Authors

Copyright 2015, Raintank, Inc. under the terms of Apache License, version 2.0. See the included LICENSE file for details.

Author:: Jeremy Bingham (<jeremy@raintank.io>)
