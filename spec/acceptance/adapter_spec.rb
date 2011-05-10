require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe "filesystem adapter" do

  it_should_behave_like "an adapter that needs setup"

  it_should_behave_like "a read-only adapter connected to a stateless storage"

  describe "setup without any data files" do

    before :each do
      GOM::Storage.teardown
      GOM::Storage::Configuration[:test_storage].hash[:files] = "invalid"
    end

    it "should raise no exception" do
      lambda do
        GOM::Storage.setup
        GOM::Storage.fetch "test_storage:object_1"
      end.should_not raise_error
    end

  end

end
