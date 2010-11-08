require 'yaml'

module GOM

  module Storage

    module Filesystem

      # The loader for the filesystem data that is provided by the storage adapter.
      class Loader

        attr_reader :directory
        attr_reader :data

        def initialize(directory)
          @directory = directory
          @data = { }
        end

        def perform
          load_yml_files
        end

        private

        def load_yml_files
          @data = { }
          Dir[File.join(@directory, "*.yml")].each do |filename|
            load_yml_file filename
          end
        end

        def load_yml_file(filename)
          classname = File.basename(filename).sub(/\..*$/, "")
          load_file_hash classname, YAML.load_file(filename)
        end

        def load_file_hash(classname, file_hash)
          file_hash.each do |id, properties|
            @data[id] = {
              :class => classname,
              :properties => properties
            }
          end
        end

      end

    end

  end

end
