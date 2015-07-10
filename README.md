# raintank-stack-cookbook

Install the entire raintank stack on one box with this cookbook, or use the individual recipes to install the different components across multiple machines.

## Supported Platforms

Currently Ubuntu 14.04. Other versions of Ubuntu, Debian, and RHEL/CentOS are coming later.

## Usage



## Attributes

See the `attributes/default.rb` file for the list of attributes this cookbook uses and their defaults. The defaults are sane, but there a few settings set in the Vagrantfile that are very important for running the all-in-one stack. The most important settings for all in one are `node[:raintank_stack][:kairosdb][:replication_factor] = 1` and `node[:raintank_stack][:ping_port] = 9090`. These settings are necessary for cassandra functioning normally with only one node (the default is 3, like in a production setting) and to avoid a port collision with the collector running locally and kairosdb. If you run this in some non-vagrant setting, take a look at the Vagrantfile for some suggested settings for the all-in-one stack.

## Usage

### raintank-stack::default

Include `raintank-stack` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[raintank-stack::default]"
  ]
}
```

## License and Authors

Copyright 2015, Raintank, Inc. under the terms of Apache License, version 2.0. See the included LICENSE file for details.

Author:: Jeremy Bingham (<jeremy@raintank.io>)
