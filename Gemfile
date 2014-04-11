source 'https://rubygems.org'

gem 'ridley',         '~> 3.0'
gem 'celluloid',      '~> 0.16.0.pre'
gem 'celluloid-io',   '~> 0.16.0.pre'
gem 'reel',           '>= 0.4.0'
gem 'http',           '~> 0.5.0' # explicitly lock because reel's is too lax
gem 'grape',          '~> 0.6'
gem 'grape-msgpack',  '~> 0.1'
gem 'hashie',         '>= 2.0.4'
gem 'faraday',        '~> 0.9.0'
gem 'retryable',      '~> 1.3.3'
gem 'archive',        '= 0.0.6'
gem 'buff-config',    '~> 0.1'
gem 'octokit',        '~> 2.6'
gem 'semverse',       '~> 1.0'

group :development do
  gem 'thor',      '~> 0.18'
  gem 'chef-zero', '~> 1.5'
  gem 'coolline'
  gem 'fuubar', '~> 1.1'
  gem 'redcarpet', platforms: :ruby
  gem 'yard'

  gem 'guard', '~> 1.8'
  gem 'guard-rspec'
  gem 'guard-spork', platforms: :ruby
end

group :development, :test do
  gem 'rack-test'
  gem 'rspec', '~> 2.13'
  gem 'spork', '~> 0.9'
end
