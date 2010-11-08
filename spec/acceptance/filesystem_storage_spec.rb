require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "filesystem"))

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "filesystem storage" do

  describe "fetching an object" do

    it "should return the correct object" do
      object = GOM::Storage.fetch "test_storage:object_1"
      object.should be_instance_of(Object)
      object.instance_variable_get(:@number).should == 5
      GOM::Object.id(object).should == "test_storage:object_1"
    end

  end

  describe "storing an object" do

    it "should raise a NoWritePermissionError" do
      lambda do
        GOM::Storage.store Object.new, "test_storage"
      end.should raise_error(GOM::Storage::NoWritePermissionError)
    end

  end

  describe "removing an object" do

    before :each do
      @object = GOM::Storage.fetch "test_storage:object_1"
    end

    it "should raise a NoWritePermissionError" do
      lambda do
        GOM::Storage.remove @object
      end.should raise_error(GOM::Storage::NoWritePermissionError)
    end

  end

end
