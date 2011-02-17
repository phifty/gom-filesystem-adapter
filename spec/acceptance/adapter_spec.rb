require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "filesystem adapter" do

  it_should_behave_like "an adapter that needs setup"

  it_should_behave_like "a read-only adapter connected to a stateless storage"

end
