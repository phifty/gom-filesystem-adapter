require 'rubygems'
gem 'rspec', '>= 2'
require 'rspec'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "gom", "filesystem-adapter"))
require 'gom/spec'

GOM::Storage.configure {
  storage {
    name :test_storage
    adapter :filesystem
    files File.join(File.dirname(__FILE__), "acceptance", "data", "*.yml")
    view {
      name :test_object_class_view
      type :class
      model_class Object
    }
  }
}
