require 'yaml'

module GOM

  module Storage

    module Filesystem

      # The loader for the filesystem data that is provided by the storage adapter.
      class Loader

        attr_accessor :directory

        def initialize(directory)
          @directory = directory
        end

        def drafts
          @drafts = { }
          load_yml_files
          @drafts
        end

        private

        def load_yml_files
          Dir[File.join(@directory, "*.yml")].each do |filename|
            load_yml_file filename
          end
        end

        def load_yml_file(filename)
          classname = File.basename(filename).sub(/\..*$/, "")
          load_file_hash classname, YAML.load_file(filename)
        end

        def load_file_hash(classname, file_hash)
          file_hash.each do |id, hash|
            @drafts[id] = Builder.new(classname, hash).draft
          end
        end

        # Builds a draft out of the file hashes.
        class Builder

          def initialize(class_name, hash)
            @class_name, @hash = class_name, hash
          end

          def draft
            @draft = GOM::Object::Draft.new
            set_class_name
            set_properties
            set_relations
            @draft
          end

          private

          def set_class_name
            @draft.class_name = @class_name
          end

          def set_properties
            properties = { }
            (@hash["properties"] || { }).each do |key, value|
              properties[key] = value
            end
            @draft.properties = properties unless properties.empty?
          end

          def set_relations
            relations = { }
            (@hash["relations"] || { }).each do |key, value|
              relations[key] = GOM::Object::Proxy.new GOM::Object::Id.new(value)
            end
            @draft.relations = relations unless relations.empty?
          end

        end

      end

    end

  end

end
