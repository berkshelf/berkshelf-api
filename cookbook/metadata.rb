lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'berkshelf/api/version'

name             "berkshelf-api"
maintainer       "Jamie Winsor"
maintainer_email "jamie@vialstudios.com"
license          "Apache 2.0"
description      "Installs/Configures a berkshelf-api server"
long_description "Installs/Configures a berkshelf-api server"
version          Berkshelf::API::VERSION

supports "ubuntu"
supports "centos"

depends "runit"
depends "nginx",      ">= 1.7.0"
depends "libarchive", "~> 0.3"
depends "github",     ">= 0.2.0"
