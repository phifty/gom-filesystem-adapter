# encoding: utf-8

Gem::Specification.new do |specification|
  specification.name              = "gom-filesystem-adapter"
  specification.version           = "0.3.1"
  specification.date              = "2011-02-17"

  specification.authors           = [ "Philipp Brüll" ]
  specification.email             = "b.phifty@gmail.com"
  specification.homepage          = "http://github.com/phifty/gom-filesystem-adapter"
  specification.rubyforge_project = "gom-filesystem-adapter"

  specification.summary           = "Filesystem storage adapter for the General Object Mapper."
  specification.description       = "Filesystem storage adapter for the General Object Mapper. Currently just read-only storage."

  specification.has_rdoc          = true
  specification.files             = [ "README.rdoc", "LICENSE", "Rakefile" ] + Dir["lib/**/*"] + Dir["spec/**/*"]
  specification.extra_rdoc_files  = [ "README.rdoc" ]
  specification.require_path      = "lib"

  specification.test_files        = Dir["spec/**/*_spec.rb"]

  specification.add_dependency "gom", ">= 0.3.1"

  specification.add_development_dependency "rspec", ">= 2"
  specification.add_development_dependency "reek", ">= 1.2"
end
