require 'serverspec'

set :backend, :exec

describe service('berks-api') do
  it { should be_running }
end
