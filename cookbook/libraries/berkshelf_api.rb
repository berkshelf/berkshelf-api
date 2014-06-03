#
# Cookbook Name:: berkshelf-api-server
# Libraries:: berkshelf_api
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

module Berkshelf
  module API
    module Chef
      class << self
        # Returns the version of the loaded tubes cookbook
        #
        # @param [Chef::RunContext] context
        #
        # @return [String]
        def cookbook_version(context)
          context.cookbook_collection["berkshelf-api-server"].version
        end
      end
    end
  end
end
