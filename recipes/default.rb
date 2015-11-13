#
# Cookbook Name:: raintank_stack
# Recipe:: default
#
# Copyright (C) 2015 Jeremy Bingham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node[:raintank_stack][:use_docker_cassandra]
  include_recipe "raintank_stack::docker"
else
  include_recipe "raintank_stack::cassandra"
end
#include_recipe "raintank_stack::mysql"
include_recipe "raintank_stack::mariadb"
include_recipe "raintank_stack::kairosdb"
include_recipe "rabbitmq"
include_recipe "rabbitmq::plugin_management"
include_recipe "redis2::default_instance"
include_recipe "java"
include_recipe "elasticsearch"
include_recipe "raintank_stack::graphite_api"
include_recipe "raintank_stack::collector"
include_recipe "raintank_stack::nsq_server"
include_recipe "raintank_stack::nsqd_init"
include_recipe "raintank_stack::nsq_metrics_to_kairos"
include_recipe "raintank_stack::nsq_metrics_to_elasticsearch"
include_recipe "raintank_stack::nsq_probe_events_to_elasticsearch"
include_recipe "grafana2"
include_recipe "raintank_stack::nginx"
include_recipe "raintank_stack::statsd"
include_recipe "golang"
