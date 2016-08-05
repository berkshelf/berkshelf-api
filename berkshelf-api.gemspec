# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'berkshelf/api/version'

Gem::Specification.new do |spec|
  spec.name          = "berkshelf-api"
  spec.version       = Berkshelf::API::VERSION
  spec.authors       = ["Jamie Winsor", "Andrew Garson"]
  spec.email         = ["jamie@vialstudios.com", "agarson@riotgames"]
  spec.description   = %q{Berkshelf dependency API server}
  spec.summary       = %q{A server which indexes cookbooks from various sources and hosts it over a REST API}
  spec.homepage      = "https://github.com/berkshelf/berkshelf-api"
  spec.license       = "Apache 2.0"

  spec.files         = Dir['CHANGELOG.md', 'README.md', 'LICENSE', 'lib/**/*']
  spec.executables   = Dir['bin/**/*'].map { |f| File.basename(f) }
  spec.test_files    = Dir['spec/**/*.rb']
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.2.0"

  spec.add_dependency 'ridley',         '>= 4.0', '< 6.0'
  spec.add_dependency 'celluloid',      '~> 0.16'
  spec.add_dependency 'celluloid-io',   '~> 0.16'
  spec.add_dependency 'reel',           '~> 0.6.0'
  spec.add_dependency 'grape',          '~> 0.14'
  spec.add_dependency 'grape-msgpack',  '~> 0.1'
  spec.add_dependency 'hashie',         '>= 2.0.4', '< 4.0.0'
  spec.add_dependency 'archive',        '= 0.0.6'
  spec.add_dependency 'buff-config',    '>= 1.0', '< 3.0'
  spec.add_dependency 'octokit',        '>= 3.0.0', '< 5.0.0'
  spec.add_dependency 'semverse',       '>= 1.0', '< 3.0'
  spec.add_dependency 'varia_model',    '~> 0.4'
end
