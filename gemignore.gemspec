# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: gemignore 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "gemignore"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Lucas Jenss"]
  s.date = "2014-01-27"
  s.description = "gemignore allows you to automatically insert a wide range of preset .gitignore snippets into your .gitignore files"
  s.email = "lucas@x3ro.de"
  s.executables = ["gemignore"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".yardopts",
    "Changelog",
    "Gemfile",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/.gitignore",
    "bin/gemignore",
    "gemignore.gemspec",
    "lib/gemignore.rb",
    "lib/gemignore/github.rb",
    "lib/gemignore/main.rb",
    "lib/gemignore/util.rb",
    "spec/gemignore_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://coding-journal.com/hassle-free-gitignore-management-with-gemignore/"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.1"
  s.summary = "A command-line tool which ought to simplify your daily .gitignore hassle"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.5.1"])
      s.add_runtime_dependency(%q<rainbow>, ["~> 1.1"])
      s.add_runtime_dependency(%q<faraday>, ["~> 0.8.9"])
      s.add_runtime_dependency(%q<octokit>, ["~> 1.0.5"])
      s.add_runtime_dependency(%q<terminal-table>, ["~> 1.4.5"])
      s.add_runtime_dependency(%q<ruby-terminfo>, ["~> 0.1.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.10.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.1"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
    else
      s.add_dependency(%q<json>, [">= 1.5.1"])
      s.add_dependency(%q<rainbow>, ["~> 1.1"])
      s.add_dependency(%q<faraday>, ["~> 0.8.9"])
      s.add_dependency(%q<octokit>, ["~> 1.0.5"])
      s.add_dependency(%q<terminal-table>, ["~> 1.4.5"])
      s.add_dependency(%q<ruby-terminfo>, ["~> 0.1.1"])
      s.add_dependency(%q<rspec>, ["~> 2.10.0"])
      s.add_dependency(%q<bundler>, ["~> 1.1"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.5.1"])
    s.add_dependency(%q<rainbow>, ["~> 1.1"])
    s.add_dependency(%q<faraday>, ["~> 0.8.9"])
    s.add_dependency(%q<octokit>, ["~> 1.0.5"])
    s.add_dependency(%q<terminal-table>, ["~> 1.4.5"])
    s.add_dependency(%q<ruby-terminfo>, ["~> 0.1.1"])
    s.add_dependency(%q<rspec>, ["~> 2.10.0"])
    s.add_dependency(%q<bundler>, ["~> 1.1"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
  end
end

