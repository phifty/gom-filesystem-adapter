require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Storage::Filesystem::Adapter do

  before :each do
    @draft = mock GOM::Object::Draft
    @drafts = mock Hash, :[] => @draft

    @loader = mock GOM::Storage::Filesystem::Loader, :drafts => @drafts
    GOM::Storage::Filesystem::Loader.stub(:new).and_return(@loader)

    @configuration = mock GOM::Storage::Configuration
    @configuration.stub(:[]).with(:directory).and_return("test_directory")
    @adapter = described_class.new @configuration
  end

  it "should register the adapter" do
    GOM::Storage::Adapter[:filesystem].should == GOM::Storage::Filesystem::Adapter
  end

  describe "setup" do

    it "should initialize a file system loader" do
      GOM::Storage::Filesystem::Loader.should_receive(:new).with("test_directory").and_return(@loader)
      @adapter.setup
    end

    it "should load the data" do
      @loader.should_receive(:drafts).and_return(@drafts)
      @adapter.setup
    end

  end

  describe "fetch" do

    before :each do
      @adapter.setup
    end

    it "should return the object hash" do
      @adapter.fetch("object_1").should == @draft
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

  describe "collection" do

    before :each do
      @adapter.setup

      @view = mock GOM::Storage::Configuration::View::Class
      @views = mock Hash, :[] => @view
      @configuration.stub(:views).and_return(@views)

      @fetcher = mock GOM::Storage::Filesystem::Collection::Fetcher
      GOM::Storage::Filesystem::Collection::Fetcher.stub(:new).and_return(@fetcher)

      @collection = mock GOM::Object::Collection
      GOM::Object::Collection.stub(:new).and_return(@collection)
    end

    it "should select the right view" do
      @views.should_receive(:[]).with(:test_object_class_view).and_return(@view)
      @adapter.collection "test_object_class_view"
    end

    it "should raise a #{described_class::ViewNotFoundError} if view name if invalid" do
      @views.stub(:[]).and_return(nil)
      lambda do
        @adapter.collection :test_object_class_view
      end.should raise_error(described_class::ViewNotFoundError)
    end

    it "should initialize the collection fetcher" do
      GOM::Storage::Filesystem::Collection::Fetcher.should_receive(:new).with(@drafts, @view).and_return(@fetcher)
      @adapter.collection :test_object_class_view
    end

    it "should initialize the collection" do
      GOM::Object::Collection.should_receive(:new).and_return(@collection)
      @adapter.collection :test_object_class_view
    end

    it "should return the collection" do
      collection = @adapter.collection :test_object_class_view
      collection.should == @collection
    end

  end

end
