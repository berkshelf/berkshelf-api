#
# Cookbook Name:: berkshelf-api-server
# Attribute:: default
#
# Copyright (C) 2013-2014 Jamie Winsor
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

default['apt']['compile_time_update'] = true
default['build-essential']['compile_time'] = true
default[:berkshelf_api][:repo]           = "berkshelf/berkshelf-api"
default[:berkshelf_api][:token]          = nil
default[:berkshelf_api][:release]        = "v#{Berkshelf::API::Chef.cookbook_version(run_context)}"
default[:berkshelf_api][:owner]          = "berkshelf"
default[:berkshelf_api][:group]          = "berkshelf"
default[:berkshelf_api][:home]           = "/etc/berkshelf/api-server"
default[:berkshelf_api][:deploy_path]    = "/opt/berkshelf-api/#{node[:berkshelf_api][:release]}"
default[:berkshelf_api][:port]           = 26200
default[:berkshelf_api][:proxy_port]     = 80
default[:berkshelf_api][:host]           = node[:fqdn] || node[:machinename] || node[:hostname]
default[:berkshelf_api][:config_path]    = "#{node[:berkshelf_api][:home]}/config.json"
default[:berkshelf_api][:config]         = {
  home_path: node[:berkshelf_api][:home]
}
