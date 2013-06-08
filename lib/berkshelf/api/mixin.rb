module Berkshelf::API
  module Mixin; end
end

Dir["#{File.dirname(__FILE__)}/mixin/*.rb"].sort.each do |path|
  require "berkshelf/api/mixin/#{File.basename(path, '.rb')}"
end
