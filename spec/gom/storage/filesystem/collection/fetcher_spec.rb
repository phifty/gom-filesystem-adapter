require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "spec_helper"))

describe GOM::Storage::Filesystem::Collection::Fetcher do

  before :each do
    @draft_one = mock GOM::Object::Draft, :class_name => "Object"
    @draft_two = mock GOM::Object::Draft, :class_name => "Test"
    @draft_three = mock GOM::Object::Draft, :class_name => nil
    @drafts = mock Hash, :values => [ @draft_one, @draft_two, @draft_three ]

    @fetcher = described_class.new @drafts, @view
  end

  describe "drafts" do

    context "for an all view" do

      before :each do
        @fetcher.view = GOM::Storage::Configuration::View::All.new
      end

      it "should return all drafts with a model class attribute" do
        drafts = @fetcher.drafts
        drafts.should include(@draft_one)
        drafts.should include(@draft_two)
        drafts.should_not include(@draft_three)
      end

    end

    context "for a class view" do

      before :each do
        @fetcher.view = GOM::Storage::Configuration::View::Class.new "Object"
      end

      it "should return an array with a selection of drafts" do
        drafts = @fetcher.drafts
        drafts.should include(@draft_one)
        drafts.should_not include(@draft_two)
        drafts.should_not include(@draft_three)
      end

    end

  end

end
