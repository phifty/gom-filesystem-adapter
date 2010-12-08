
module GOM

  module Storage

    module Filesystem

      # The filesystem storage adapter
      class Adapter < GOM::Storage::Adapter

        def initialize(configuration)
          super configuration
        end

        def setup
          load_data
        end

        def fetch(id)
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
          @data = GOM::Storage::Filesystem::Loader.new(configuration[:directory]).data
        end

        def read_only_error(method_name)
          raise GOM::Storage::ReadOnlyError, "The adapter doesn't provide write methods"
        end

      end

    end

  end

end
