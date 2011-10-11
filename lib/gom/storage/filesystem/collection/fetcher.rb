
# A class collection fetcher for the filesystem adapter.
class GOM::Storage::Filesystem::Collection::Fetcher

  attr_accessor :drafts
  attr_accessor :view

  def initialize(drafts, view)
    @drafts, @view = drafts, view
  end

  def drafts
    if @view.is_a?(GOM::Storage::Configuration::View::All)
      @drafts.values.select{ |draft| !draft.class_name.nil? }
    else
      @drafts.values.select{ |draft| draft.class_name == @view.class_name.to_s }
    end
  end

end
