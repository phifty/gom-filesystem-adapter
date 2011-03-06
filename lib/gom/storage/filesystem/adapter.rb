
# The filesystem storage adapter
class GOM::Storage::Filesystem::Adapter < GOM::Storage::Adapter

  attr_reader :drafts

  def setup
    load_drafts
  end

  def teardown
    @drafts = nil
  end

  def fetch(id)
    check_setup
    @drafts[id]
  end

  def store(*arguments)
    check_setup
    read_only_error
  end

  def remove(*arguments)
    check_setup
    read_only_error
  end

  def count
    check_setup
    @drafts.size
  end

  def collection(view_name, options = { })
    check_setup
    configuration = self.configuration
    view = configuration.views[view_name.to_sym]
    raise ViewNotFoundError, "there are no view with the name #{view_name}" unless view
    GOM::Object::Collection.new GOM::Storage::Filesystem::Collection::Fetcher.new(@drafts, view), configuration.name
  end

  private

  def check_setup
    raise GOM::Storage::Adapter::NoSetupError unless @drafts
  end

  def load_drafts
    @drafts = GOM::Storage::Filesystem::Loader.new(configuration[:files]).drafts
  end

  def read_only_error
    raise GOM::Storage::ReadOnlyError, "The adapter doesn't provide write methods"
  end

end
