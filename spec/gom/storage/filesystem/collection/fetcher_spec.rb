require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "spec_helper"))

describe GOM::Storage::Filesystem::Collection::Fetcher do

  before :each do
    @draft_one = mock GOM::Object::Draft, :class_name => "Object"
    @draft_two = mock GOM::Object::Draft, :class_name => "Test"
    @drafts = mock Hash, :values => [ @draft_one, @draft_two ]
    @view = mock GOM::Storage::Configuration::View::Class, :class_name => "Object"

    @fetcher = described_class.new @drafts, @view
  end

  describe "drafts" do

    it "should return an array with a selection of drafts" do
      drafts = @fetcher.drafts
      drafts.should include(@draft_one)
      drafts.should_not include(@draft_two)
    end

  end

end
