# Berkshelf::API
[![Gem Version](https://badge.fury.io/rb/berkshelf-api.svg)](http://badge.fury.io/rb/berkshelf-api)
[![Build Status](https://travis-ci.org/berkshelf/berkshelf-api.svg?branch=master)](https://travis-ci.org/berkshelf/berkshelf-api)

A server which indexes cookbooks from various sources and hosts it over a REST API

## Installation

The API server can be installed in two ways; from a Chef Cookbook (recommended) and from a Rubygem.

## Supports

Chef >= 12.2
Ubuntu 12.04/16.04
RHEL/CentOS 6.x/7.x

### Cookbook install

#### Basic

1. Select a [release](https://github.com/berkshelf/berkshelf-api/releases) and download its cookbooks artifact (`cookbooks.tar.gz`).
2. Upload the cookbooks to your Chef Server if you're using Chef Client or just give them to Chef Solo if that's your thing.
3. Add "recipe[berkshelf-api-server::default]" to your node's run_list and run Chef.

#### Express

Install and configure [Chef/Knife](https://github.com/opscode/chef) and [Berkflow](https://github.com/reset/berkflow) on your machine.

Create an environment

    $ knife environment create berks-api-production -d

Bootstrap a server into that environment

    $ knife ec2 server create -I ami-23f78e13 -f t1.micro -E berks-api-production -r "recipe[organization-base::default]" -G ssh-admin,http-https --ssh-user ubuntu

Install the cookbooks into your environment

    $ blo in https://github.com/berkshelf/berkshelf-api/releases/download/v1.3.1/cookbooks.tar.gz

Add the recipe to your new node's run_list

    $ knife node run_list add i-c8cd9ac1 "recipe[berkshelf-api-server::default]"

Edit the environment to configure the API server

    $ knife environment edit berks-api-production

And add your configuration to the `node[:berkshelf_api][:config]` attribute

```json
"default_attributes": {
  "berkshelf_api": {
    "config": {
      "endpoints": [
        {
          "type": "chef_server",
          "options": {
            "url": "https://api.opscode.com/organizations/vialstudios",
            "client_key": "/etc/berkshelf/api-server/client.pem",
            "client_name": "berkshelf"
          }
        }
      ],
      "build_interval": 5.0
    },
    "host": "your.fqdn.here"
  }
}
```

Options:

  * build_interval - the number of seconds before it refreshes from the endpoints.
  * endpoints - an array of endpoints to cache
  * home_path - data directory for the berkshelf-api server

> See configuration endpoints below for a complete list of supported endpoints, and the [api cookbook readme](https://github.com/berkshelf/berkshelf-api/tree/master/cookbook) for all configuration options.

Update the machine you bootstrapped to the latest version of Berkshelf-API

    $ blo up berks-api-production berkshelf-api-server latest

### Gem install

    $ gem install berkshelf-api

## Running the server

    $ berks-api
    I, [2014-02-21T12:05:07.639699 #43671]  INFO -- : Cache Manager starting...
    I, [2014-02-21T12:05:07.639883 #43671]  INFO -- : Loading save from /Users/reset/.berkshelf/api-server/cerch
    I, [2014-02-21T12:05:07.640462 #43671]  INFO -- : Cache contains 0 items
    I, [2014-02-21T12:05:07.641021 #43671]  INFO -- : Cache Builder starting...
    I, [2014-02-21T12:05:07.723779 #43671]  INFO -- : REST Gateway listening on 0.0.0.0:26200

## Supported Platforms

Berkshelf-API is tested on Ruby 1.9.3, 2.0.0, and JRuby 1.7+.

Ruby 1.9 mode is required on all interpreters.

## Configuring Endpoints

You may configure the endpoints to index by editing the JSON configuration file (default: `#{ENV['HOME']}/.berkshelf/api-server/config.json`).

### Supermarket Community Site

Please note: this is unnecessary. You may point your Berksfile at "https://supermarket.getchef.com" instead.

```json
{
  "endpoints": [
    { "type": "supermarket" }
  ]
}
```

### Supermarket "Behind the Firewall"

Please note: this is unnecessary. You may point your Berksfile at "https://your-supermarket-install.example.com" instead.


```json
{
  "endpoints": [
    {
      "type": "supermarket",
      "options": {
        "url": "https://your-supermarket-install.example.com/"
      }
    }
  ]
}
```

### Chef Server

```json
{
  "endpoints": [
    {
      "type": "chef_server",
      "options": {
        "url": "https://api.opscode.com/organizations/vialstudios",
        "client_name": "berkshelf",
        "client_key": "/etc/berkshelf/api-server/client.pem"
      }
    }
  ]
}
```

### GitHub Organization

> WARNING: Using the GitHub endpoint is *STRONGLY FROWNED UPON* and potentially *DANGEROUS*. Please consider setting up a proper release process for the cookbooks you wish to index instead where they are uploaded to the community site or a Chef Server and use the chef_server endpoint instead.

GitHub limits the rate of requests to their API if not authenticated. For this reason the access_token option
is required. The api_endpoint, web_endpoint and ssl_verify options are only needed when you want to point to
a GitHub Enterprise server within your own organization

```json
{
  "endpoints": [
    {
      "type": "github",
      "options": {
        "organization": "opscode-cookbooks",
        "access_token": "",
        "api_endpoint": "https://github.enterprise.local/api/v3",
        "web_endpoint": "https://github.enterprise.local",
        "ssl_verify": true
      }
    }
  ]
}
```

### FileStore directory

A local directory containing cookbooks.

```json
{
  "endpoints": [
    {
      "type": "file_store",
      "options": {
        "path": "/Users/chef/code/cookbooks"
      }
    }
  ]
}
```

## Getting Help

* If you have an issue: report it on the [issue tracker](https://github.com/berkshelf/berkshelf/issues)
* If you have a question: visit the #chef or #berkshelf channel on irc.freenode.net

# Authors and Contributors

* Jamie Winsor (<jamie@vialstudios.com>)
* Andrew Garson (<agarson@riotgames.com>)

Thank you to all of our [Contributors](https://github.com/berkshelf/berkshelf-api/graphs/contributors), testers, and users.
