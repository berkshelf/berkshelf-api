#
# Cookbook Name:: berkshelf-api-server
# Recipe:: http_proxy
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

include_recipe "apt" if node["platform_family"] == "debian"
node.force_default[:nginx][:install_method] = "source"
include_recipe "nginx"

nginx_site "default" do
  enable false
end

template "#{node[:nginx][:dir]}/sites-available/berks-api" do
  source "berks-api-nginx.erb"
  notifies :reload, "service[nginx]"
end

nginx_site "berks-api" do
  enable true
end
