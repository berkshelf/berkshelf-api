#
# Cookbook Name:: berkshelf-api-server
# Recipe:: app
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

include_recipe "runit"

chef_gem "bundler"

group node[:berkshelf_api][:group]

user node[:berkshelf_api][:owner] do
  gid node[:berkshelf_api][:group]
  home node[:berkshelf_api][:home]
  system true
end

directory node[:berkshelf_api][:home] do
  owner node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  recursive true
end

file node[:berkshelf_api][:config_path] do
  content JSON.generate(node[:berkshelf_api][:config].to_hash)
end

ark node[:berkshelf_api][:release] do
  owner node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  url "#{node[:berkshelf_api][:home]}/berkshelf-api.tar.gz"
  prefix_root '/opt/berkshelf-api/'
  action :put
  notifies :restart, 'runit_service[berks-api]'
end

execute "berkshelf-api-bundle-install" do
  user node[:berkshelf_api][:owner]
  group node[:berkshelf_api][:group]
  cwd node[:berkshelf_api][:deploy_path]
  command "/opt/chef/embedded/bin/bundle install --deployment --without development test"
  not_if "cd #{node[:berkshelf_api][:deploy_path]} && /opt/chef/embedded/bin/bundle check"
end

runit_service "berks-api" do
  sv_timeout 30
  action :enable
end
