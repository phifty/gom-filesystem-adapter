require 'gom'
require File.join(File.dirname(__FILE__), "gom", "storage")

GOM::Storage::Adapter.register :filesystem, GOM::Storage::Filesystem::Adapter
