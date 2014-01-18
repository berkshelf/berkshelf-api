class Pathname
  # Returns true or false if the path contains a "metadata.json" or a "metadata.rb" file.
  #
  # @return [Boolean]
  def cookbook?
    join("metadata.json").exist? || join("metadata.rb").exist?
  end
  alias_method :chef_cookbook?, :cookbook?
end
