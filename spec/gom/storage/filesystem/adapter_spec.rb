require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Storage::Filesystem::Adapter do

  before :each do
    @data = {
      "object_1" => {
        :class => "Object",
        :properties => { :test => "test value" }
      },
      "object_2" => {
        :class => "Object",
        :properties => { :test => "another test value" }
      }
    }

    @loader = mock GOM::Storage::Filesystem::Loader, :perform => nil, :data => @data
    GOM::Storage::Filesystem::Loader.stub(:new).and_return(@loader)

    @configuration = mock GOM::Storage::Configuration
    @configuration.stub(:values_at) do |*arguments|
      result = nil
      result = [ "test_directory", "test_relation_detector" ] if arguments == [ :directory, :relation_detector ]
      result
    end
    @adapter = GOM::Storage::Filesystem::Adapter.new @configuration
  end

  it "should register the adapter" do
    GOM::Storage::Adapter[:filesystem].should == GOM::Storage::Filesystem::Adapter
  end

  describe "fetch" do

    it "should initialize the loader correctly" do
      GOM::Storage::Filesystem::Loader.should_receive(:new).with("test_directory", "test_relation_detector").and_return(@loader)
      @adapter.fetch "object_1"
    end

    it "should load the data" do
      @loader.should_receive(:perform)
      @adapter.fetch "object_1"
    end

    it "should return the object hash" do
      @adapter.fetch("object_1").should == @data["object_1"]
    end

  end

  describe "store" do

    it "should raise a GOM::Storage::ReadOnlyError" do
      lambda do
        @adapter.store Object.new, "test_storage"
      end.should raise_error(GOM::Storage::ReadOnlyError)
    end

  end

  describe "remove" do

    it "should raise a GOM::Storage::ReadOnlyError" do
      lambda do
        @adapter.remove Object.new
      end.should raise_error(GOM::Storage::ReadOnlyError)
    end

  end

end
