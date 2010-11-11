
module GOM

  module Storage

    module Filesystem

      # The filesystem storage adapter
      class Adapter < GOM::Storage::Adapter

        def initialize(configuration)
          super configuration
        end

        def fetch(id)
          load_data
          @data[id]
        end

        def store(object, storage_name = nil)
          no_write_permission "store"
        end

        def remove(object)
          no_write_permission "remove"
        end

        private

        def load_data
          loader = GOM::Storage::Filesystem::Loader.new self.configuration[:directory], self.configuration[:relation_detector]
          loader.perform
          @data = loader.data
        end

        def no_write_permission(method_name)
          raise GOM::Storage::NoWritePermissionError, "The adapter doesn't provide write methods"
        end

      end

    end

  end

end
