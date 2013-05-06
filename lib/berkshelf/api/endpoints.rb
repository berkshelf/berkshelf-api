Dir["#{File.dirname(__FILE__)}/endpoints/*.rb"].sort.each do |path|
  require "berkshelf/api/endpoints/#{File.basename(path, '.rb')}"
end
