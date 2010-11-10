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
          file_hash.each do |id, hash|
            @data[id] = Builder.new(classname, hash).object_hash
          end
        end

        # Builds an object hash out of the file hashes.
        class Builder

          attr_reader :object_hash

          def initialize(classname, hash)
            @classname, @hash = classname, hash
            @object_hash = { }
            copy_classname
            copy_properties
            copy_relations
          end

          private

          def copy_classname
            @object_hash[:class] = @classname
          end

          def copy_properties
            properties = { }
            @hash.keys.select{ |key| !(key =~ /_id$/) }.each do |key|
              properties[key] = @hash[key]
            end
            @object_hash[:properties] = properties unless properties.empty?
          end

          def copy_relations
            relations = { }
            @hash.keys.select{ |key| key =~ /_id$/ }.each do |key|
              name = key.sub /_id$/, ""
              relations[name] = GOM::Object::Proxy.new GOM::Object::Id.new(@hash[key])
            end
            @object_hash[:relations] = relations unless relations.empty?
          end

        end

      end

    end

  end

end
