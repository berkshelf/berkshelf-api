source 'https://rubygems.org'

gemspec

group :development do
  gem 'coolline'
  gem 'fuubar'
  gem 'redcarpet', platforms: :ruby
  gem 'yard'

  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork', platforms: :ruby

  require 'rbconfig'

  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'growl', require: false
    gem 'rb-fsevent', require: false

    if `uname`.strip == 'Darwin' && `sw_vers -productVersion`.strip >= '10.8'
      gem 'terminal-notifier-guard', '~> 1.5.3', require: false
    end rescue Errno::ENOENT
  elsif RbConfig::CONFIG['target_os'] =~ /linux/i
    gem 'libnotify', require: false
    gem 'rb-inotify', require: false
  elsif RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
    gem 'rb-notifu', '>= 0.0.4', require: false
    gem 'wdm', require: false
    gem 'win32console', require: false
  end
end

group :development, :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'spork'
end
