
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
          read_only_error "store"
        end

        def remove(object)
          read_only_error "remove"
        end

        private

        def load_data
          directory, relation_detector = configuration.values_at :directory, :relation_detector
          loader = GOM::Storage::Filesystem::Loader.new directory, relation_detector
          loader.perform
          @data = loader.data
        end

        def read_only_error(method_name)
          raise GOM::Storage::ReadOnlyError, "The adapter doesn't provide write methods"
        end

      end

    end

  end

end
