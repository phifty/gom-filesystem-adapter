require 'yaml'

# The loader for the filesystem data that is provided by the storage adapter.
class GOM::Storage::Filesystem::Loader

  attr_accessor :files

  def initialize(files)
    @files = files
  end

  def drafts
    @drafts = { }
    load_yml_files
    @drafts
  end

  private

  def load_yml_files
    Dir[@files].each do |filename|
      load_yml_file filename
    end
  end

  def load_yml_file(filename)
    load_file_hash YAML.load_file(filename)
  end

  def load_file_hash(file_hash)
    file_hash.each do |object_id, hash|
      @drafts[object_id] = Builder.new(object_id, hash).draft
    end
  end

  # Builds a draft out of the file hashes.
  class Builder

    def initialize(object_id, hash)
      @object_id, @hash = object_id, hash
    end

    def draft
      initialize_draft
      set_class_name
      set_properties
      set_relations
      @draft
    end

    private

    def initialize_draft
      @draft = GOM::Object::Draft.new @object_id
    end

    def set_class_name
      @draft.class_name = @hash["class"] || "Object"
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
