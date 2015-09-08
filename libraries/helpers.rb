#
# Cookbook Name:: raintank_stack
# Library: helpers
#
# Copyright (C) 2015 Raintank, Inc.
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

# This is rather GCE specific right now.

module RaintankStack
  module Helpers
    def find_haproxy
      return nil? unless node.attribute?('gce')
      zone = node['gce']['instance']['zone']
      haproxy = search("node", node['raintank_stack']['haproxy_search'])
      h = haproxy.select { |h| h['gce']['instance']['zone'] == zone }.first
      return (h) ? h.ipaddress : nil
    end
    def find_nsqd
      # eventually we'll want to limit this search to only the same zone
      nsqds = search("node", node['raintank_stack']['nsqd_search'])
      return nsqds.map { |n| n.ipaddress }
    end
  end
end

Chef::Recipe.send(:include, ::RaintankStack::Helpers)
Chef::Resource.send(:include, ::RaintankStack::Helpers)
Chef::Provider.send(:include, ::RaintankStack::Helpers)
