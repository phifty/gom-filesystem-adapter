require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Storage::Filesystem::Loader do

  before :each do
    @directory = "directory"
    @loader = GOM::Storage::Filesystem::Loader.new @directory
  end

  describe "initialize" do

    it "should set the directory" do
      @loader.directory.should == @directory
    end

  end

  describe "perform" do

    before :each do
      @filename = "directory/Object.yml"
      @filenames = [ @filename ]
      Dir.stub!(:[]).and_return(@filenames)

      @proxy = Object.new
      GOM::Object::Proxy.stub!(:new).and_return(@proxy)

      @file_hash = {
        "object_1" => {
          "test" => "test value",
          "related_object_id" => "test_storage:object_2"
        },
        "object_2" => {
          "test" => "another test value"
        }
      }
      YAML.stub!(:load_file).and_return(@file_hash)
    end

    it "should searches all .yml file in the directory" do
      Dir.should_receive(:[]).with("directory/*.yml").and_return(@filenames)
      @loader.perform
    end

    it "should load the files" do
      YAML.should_receive(:load_file).with(@filename).and_return(@file_hash)
      @loader.perform
    end

    it "should create object proxies for properties with '_id' suffixes" do
      GOM::Object::Proxy.should_receive(:new).with(GOM::Object::Id.new("test_storage:object_2")).and_return(@proxy)
      @loader.perform
    end

    it "should convert the file hash into object hashes" do
      @loader.perform
      @loader.data.should == {
        "object_1" => {
          :class => "Object",
          :properties => { "test" => "test value" },
          :relations => { "related_object" => @proxy }
        },
        "object_2" => {
          :class => "Object",
          :properties => { "test" => "another test value" }
        }
      }
    end

  end

end