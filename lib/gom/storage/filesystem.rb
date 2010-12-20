
module GOM

  module Storage

    module Filesystem

      autoload :Adapter, File.join(File.dirname(__FILE__), "filesystem", "adapter")
      autoload :Collection, File.join(File.dirname(__FILE__), "filesystem", "collection")
      autoload :Loader, File.join(File.dirname(__FILE__), "filesystem", "loader")

    end

  end

end
