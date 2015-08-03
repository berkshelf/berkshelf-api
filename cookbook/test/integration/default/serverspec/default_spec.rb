require 'serverspec'

set :backend, :exec

describe 'berkshelf-api-server::default' do
  service('berks-api') do
    it { should be_running }
  end
end
