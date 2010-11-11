# encoding: UTF-8
require 'rubygems'
gem 'rspec'
require 'rspec'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rspec/core/rake_task'

task :default => :spec

specification = Gem::Specification.new do |specification|
  specification.name              = "gom-filesystem"
  specification.version           = "0.0.1"
  specification.date              = "2010-11-11"

  specification.authors           = [ "Philipp Brüll" ]
  specification.email             = "b.phifty@gmail.com"
  specification.homepage          = "http://github.com/phifty/gom-filesystem"
  specification.rubyforge_project = "gom-filesystem"

  specification.summary           = "Filesystem storage adapter for the General Object Mapper."
  specification.description       = "Filesystem storage adapter for the General Object Mapper. Currently just read-only storage."

  specification.has_rdoc          = true
  specification.files             = [ "README.rdoc", "LICENSE", "Rakefile" ] + Dir["lib/**/*"] + Dir["spec/**/*"]
  specification.extra_rdoc_files  = [ "README.rdoc" ]
  specification.require_path      = "lib"

  specification.test_files        = Dir["spec/**/*_spec.rb"]

  specification.add_dependency "gom", ">= 0.0.1"
end

Rake::GemPackageTask.new(specification) do |package|
  package.gem_spec = specification
end

desc "Generate the rdoc"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.add [ "README.rdoc", "lib/**/*.rb" ]
  rdoc.main  = "README.rdoc"
  rdoc.title = ""
end

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new do |task|
  task.pattern = "spec/gom/**/*_spec.rb"
end

namespace :spec do

  desc "Run all integration specs in spec/acceptance directory"
  RSpec::Core::RakeTask.new(:acceptance) do |task|
    task.pattern = "spec/acceptance/**/*_spec.rb"
  end

end
