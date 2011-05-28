# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gemignore}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lucas Jenss"]
  s.date = %q{2011-05-28}
  s.default_executable = %q{gemignore}
  s.description = %q{gemignore allows you to automatically insert a wide range of preset .gitignore snippets into your .gitignore files}
  s.email = %q{lucas@x3ro.de}
  s.executables = ["gemignore"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Changelog",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/.gitignore",
    "bin/gemignore",
    "gemignore.gemspec",
    "lib/gemignore.rb",
    "lib/gemignore/main.rb",
    "lib/gemignore/util.rb",
    "spec/gemignore_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/x3ro/gemignore}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A command-line tool which ought to simplify your daily .gitignore hassle}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.5.1"])
      s.add_runtime_dependency(%q<rainbow>, ["~> 1.1.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 1.5.1"])
      s.add_dependency(%q<rainbow>, ["~> 1.1.1"])
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.5.1"])
    s.add_dependency(%q<rainbow>, ["~> 1.1.1"])
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

