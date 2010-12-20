
module GOM

  module Storage

    module Filesystem

      module Collection

        # A class collection fetcher for the filesystem adapter.
        class Fetcher

          attr_accessor :drafts
          attr_accessor :view

          def initialize(drafts, view)
            @drafts, @view = drafts, view
          end

          def drafts
            @drafts.values.select{ |draft| draft.class_name == @view.class_name }
          end

        end

      end

    end

  end

end
