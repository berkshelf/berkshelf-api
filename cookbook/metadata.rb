lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'berkshelf/api/version'

name             "berkshelf-api-server"
maintainer       "Jamie Winsor"
maintainer_email "jamie@vialstudios.com"
license          "Apache 2.0"
description      "Installs/Configures a berkshelf-api server"
long_description "Installs/Configures a berkshelf-api server"
version          Berkshelf::API::VERSION
source_url       'https://github.com/berkshelf/berkshelf-api'
issues_url       'https://github.com/berkshelf/berkshelf-api/issues'

chef_version ">= 12.2.0"

%w{ redhat centos ubuntu }.each do |os|
  supports os
end

depends "runit"
depends "build-essential", ">= 2.0.2"
depends "nginx",           ">= 1.7.0"
depends "libarchive",      ">= 0.4"
depends "github",          ">= 0.3"
depends "apt"
