# Berkshelf::API
[![Gem Version](https://badge.fury.io/rb/berkshelf-api.png)](http://badge.fury.io/rb/berkshelf-api)
[![Build Status](https://secure.travis-ci.org/RiotGames/berkshelf-api.png?branch=master)](http://travis-ci.org/RiotGames/berkshelf-api)
[![Dependency Status](https://gemnasium.com/RiotGames/berkshelf-api.png?travis)](https://gemnasium.com/RiotGames/berkshelf-api)
[![Code Climate](https://codeclimate.com/github/RiotGames/berkshelf-api.png)](https://codeclimate.com/github/RiotGames/berkshelf-api)

A server which indexes cookbooks from various sources and hosts it over a REST API

## Installation

    $ gem install berkshelf-api

## Usage

### Help

    $ berks-api help -h
    Usage: berks-api [options]
        -p, --port PORT                  set the listening port
        -v, --verbose                    run with verbose output
        -d, --debug                      run with debug output
        -q, --quiet                      silence output
        -c, --config FILE                path to a configuration file to use
        -h, --help                       show this message

### Start a default berkshelf-api server

    $ berks-api
    I, [2013-11-04T15:00:39.352139 #6762]  INFO -- : Cache Manager starting...
    I, [2013-11-04T15:00:39.352337 #6762]  INFO -- : Loading save from /Users/teemo/.berkshelf/api-server/cerch
    I, [2013-11-04T15:00:39.352724 #6762]  INFO -- : Cache contains 0 items
    I, [2013-11-04T15:00:39.353334 #6762]  INFO -- : Cache Builder starting...
    I, [2013-11-04T15:00:39.550990 #6762]  INFO -- : REST Gateway listening on 0.0.0.0:26200
    I, [2013-11-04T15:00:39.595797 #6762]  INFO -- : processing #<Berkshelf::API::CacheBuilder::Worker::Opscode:0x007fd19d0ddf10>
    I, [2013-11-04T15:01:12.927892 #6762]  INFO -- : found 4477 cookbooks from #<Berkshelf::API::CacheBuilder::Worker::Opscode:0x007fd19d0ddf10>
    I, [2013-11-04T15:01:12.935696 #6762]  INFO -- : processing metadata for 500 cookbooks with 3977 remaining on #<Berkshelf::API::CacheBuilder::Worker::Opscode:0x007fd19d0ddf10>

## Configuration File

* `home_path` [String] Location where the api-server should store its cache (e.g. /opt/berkshelf-api-server) Default: ~/.berkshelf/api-server
* `endpoints` [Array] Configuration hashes to define what endpoints should be cached. (e.g. See [Configuring Endpoints](https://github.com/RiotGames/berkshelf-api/#configuring-endpoints))

## Supported Platforms

Berkshelf-API is tested on Ruby 1.9.3, 2.0.0, and JRuby 1.7+.

Ruby 1.9 mode is required on all interpreters.

Ruby 1.9.1 and 1.9.2 are not officially supported. If you encounter problems, please upgrade to Ruby 2.0 or 1.9.3.

## Configuring Endpoints

You may configure the endpoints to index by editing the JSON configuration file (default: `~/.berkshelf/api-server/config.json`).

### Opscode Community Site

````json
{
  "endpoints": [
    {
      "type": "opscode",
      "options": {
        "url": "http://cookbooks.opscode.com/api/v1"
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Authors and Contributors

* Jamie Winsor (<jamie@vialstudios.com>)
* Andrew Garson (<agarson@riotgames.com>)

Thank you to all of our [Contributors](https://github.com/RiotGames/berkshelf-api/graphs/contributors), testers, and users.
