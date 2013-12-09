# Berkshelf::API
[![Gem Version](https://badge.fury.io/rb/berkshelf-api.png)](http://badge.fury.io/rb/berkshelf-api)
[![Build Status](https://secure.travis-ci.org/berkshelf/berkshelf-api.png?branch=master)](http://travis-ci.org/berkshelf/berkshelf-api)

A server which indexes cookbooks from various sources and hosts it over a REST API

## Installation

    $ gem install berkshelf-api

## Usage

TODO: Write usage instructions here

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

### Github Organization

Github limits the rate of requests to their API if not authenticated. For this reason the access_token option
is required.

```json
{
  "endpoints": [
    {
      "type": "github",
      "options": {
        "organization": "opscode-cookbooks",
        "access_token": ""
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

Thank you to all of our [Contributors](https://github.com/berkshelf/berkshelf-api/graphs/contributors), testers, and users.
