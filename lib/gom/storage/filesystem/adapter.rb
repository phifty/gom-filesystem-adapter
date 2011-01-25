
module GOM

  module Storage

    module Filesystem

      # The filesystem storage adapter
      class Adapter < GOM::Storage::Adapter

        def setup
          load_drafts
        end

        def fetch(id)
          @drafts[id]
        end

        def store(*arguments)
          read_only_error
        end

        def remove(*arguments)
          read_only_error
        end

        def collection(view_name, options = { })
          view = configuration.views[view_name.to_sym]
          raise ViewNotFoundError, "there are no view with the name #{view_name}" unless view
          fetcher = Collection::Fetcher.new @drafts, view
          GOM::Object::Collection.new fetcher
        end

        private

        def load_drafts
          @drafts = GOM::Storage::Filesystem::Loader.new(configuration[:files]).drafts
        end

        def read_only_error
          raise GOM::Storage::ReadOnlyError, "The adapter doesn't provide write methods"
        end

      end

    end

  end

end
