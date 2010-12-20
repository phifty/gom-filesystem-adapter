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

  describe "drafts" do

    before :each do
      @filename = "directory/Object.yml"
      @filenames = [ @filename ]
      Dir.stub(:[]).and_return(@filenames)

      @proxy = mock GOM::Object::Proxy
      GOM::Object::Proxy.stub(:new).and_return(@proxy)

      @file_hash = {
        "object_1" => {
          "properties" => {
            "test" => "test value"
          },
          "relations" => {
            "related_object" => "test_storage:object_2"
          }
        },
        "object_2" => {
          "properties" => {
            "test" => "another test value"
          }
        }
      }
      YAML.stub(:load_file).and_return(@file_hash)
    end

    it "should searches all .yml file in the directory" do
      Dir.should_receive(:[]).with("directory/*.yml").and_return(@filenames)
      @loader.drafts
    end

    it "should load the files" do
      YAML.should_receive(:load_file).with(@filename).and_return(@file_hash)
      @loader.drafts
    end

    it "should create object proxies for relations" do
      GOM::Object::Proxy.should_receive(:new).with(GOM::Object::Id.new("test_storage:object_2")).and_return(@proxy)
      @loader.drafts
    end

    it "should convert the file hash into drafts" do
      draft_one = @loader.drafts["object_1"]
      draft_one.class_name.should == "Object"
      draft_one.properties.should == { "test" => "test value" }
      draft_one.relations.should == { "related_object" => @proxy }

      draft_two = @loader.drafts["object_2"]
      draft_two.class_name.should == "Object"
      draft_two.properties.should == { "test" => "another test value" }
    end

  end

end
