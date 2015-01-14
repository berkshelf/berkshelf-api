source 'https://rubygems.org'

gemspec

group :development do
  gem 'berkflow', github: "reset/berkflow"
  gem 'berkshelf', github: "berkshelf/berkshelf"
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
  gem 'chef-zero', '~> 3.2'
  gem 'rack-test'
  gem 'rspec', '~> 2.13'
  gem 'spork', '~> 0.9'
end
