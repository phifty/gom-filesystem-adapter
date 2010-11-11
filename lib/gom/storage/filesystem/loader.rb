require 'yaml'

module GOM

  module Storage

    module Filesystem

      # The loader for the filesystem data that is provided by the storage adapter.
      class Loader

        attr_accessor :directory
        attr_accessor :relation_detector
        attr_reader :data

        def initialize(directory, relation_detector = "_id$")
          @directory, @relation_detector = directory, relation_detector
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
            @data[id] = Builder.new(classname, hash, @relation_detector).object_hash
          end
        end

        # Builds an object hash out of the file hashes.
        class Builder

          attr_reader :object_hash

          def initialize(classname, hash, relation_detector)
            @classname, @hash, @relation_detector = classname, hash, Regexp.new(relation_detector)
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
            @hash.keys.select{ |key| !relation?(key) }.each do |key|
              properties[key] = @hash[key]
            end
            @object_hash[:properties] = properties unless properties.empty?
          end

          def copy_relations
            relations = { }
            @hash.keys.select{ |key| relation?(key) }.each do |key|
              name = key.sub @relation_detector, ""
              relations[name] = GOM::Object::Proxy.new GOM::Object::Id.new(@hash[key])
            end
            @object_hash[:relations] = relations unless relations.empty?
          end

          def relation?(key)
            @relation_detector.match key
          end

        end

      end

    end

  end

end
