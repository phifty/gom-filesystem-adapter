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

    @loader = Object.new
    @loader.stub!(:perform)
    @loader.stub!(:data).and_return(@data)
    GOM::Storage::Filesystem::Loader.stub!(:new).and_return(@loader)

    @configuration = Object.new
    @configuration.stub!(:[])
    @adapter = GOM::Storage::Filesystem::Adapter.new @configuration
  end

  it "should register the adapter" do
    GOM::Storage::Adapter[:filesystem].should == GOM::Storage::Filesystem::Adapter
  end

  describe "fetch" do

    it "should load the data" do
      @loader.should_receive(:perform)
      @adapter.fetch "object_1"
    end

    it "should return the object hash" do
      @adapter.fetch("object_1").should == @data["object_1"]
    end

  end

  describe "store" do

    it "should raise a GOM::Storage::NoWritePermissionError" do
      lambda do
        @adapter.store Object.new, "test_storage"
      end.should raise_error(GOM::Storage::NoWritePermissionError)
    end

  end

  describe "remove" do

    it "should raise a GOM::Storage::NoWritePermissionError" do
      lambda do
        @adapter.remove Object.new
      end.should raise_error(GOM::Storage::NoWritePermissionError)
    end

  end

end