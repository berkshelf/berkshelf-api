source 'https://rubygems.org'

gemspec

group :development do
  gem 'berkflow', git: "https://github.com/reset/berkflow.git"
  gem 'berkshelf', git: "https://github.com/berkshelf/berkshelf.git"
  gem 'thor',      '~> 0.18'
  gem 'coolline'
  gem 'fuubar', '~> 1.1'
  gem 'redcarpet', platforms: :ruby
  gem 'yard'

  gem 'guard', '~> 1.8'
  gem 'guard-rspec'
  gem 'guard-spork', platforms: :ruby
end

group :development, :test do
  gem 'chef-zero', '~> 1.5'
  gem 'rack-test'
  gem 'rspec', '~> 2.13'
  gem 'spork', '~> 0.9'
end
