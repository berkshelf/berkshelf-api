$:.push File.expand_path("../../lib", __FILE__)

require 'rubygems'
require 'bundler'
require 'rspec'
require 'spork'
require 'rack/test'

Spork.prefork do
  Dir[File.join(File.expand_path("../../spec/support/**/*.rb", __FILE__))].each { |f| require f }

  RSpec.configure do |config|
    config.include Berkshelf::RSpec::ChefServer

    config.expect_with :rspec do |c|
      c.syntax = :expect
    end

    config.mock_with :rspec
    config.filter_run focus: true
    config.run_all_when_everything_filtered = true

    config.before(:suite) { Berkshelf::RSpec::ChefServer.start }
    config.before(:all) { Berkshelf::API::Logging.init(location: '/dev/null') }

    config.before do
      Celluloid.shutdown
      Celluloid.boot
      ENV['BERKSHELF_API_PATH'] = tmp_path.join('api-server').to_s
      clean_tmp_path
    end
  end

  def app_root_path
    Pathname.new(File.expand_path('../../', __FILE__))
  end

  def tmp_path
    app_root_path.join('spec/tmp')
  end

  def fixtures_path
    app_root_path.join('spec/fixtures')
  end

  def clean_tmp_path
    FileUtils.rm_rf(tmp_path)
    FileUtils.mkdir_p(tmp_path)
  end
end

Spork.each_run do
  require 'berkshelf/api'
end
