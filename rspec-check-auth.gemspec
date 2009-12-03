# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-check-auth}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Caius Durling"]
  s.date = %q{2009-12-03}
  s.description = %q{Quickly check your rails controller actions require authentication}
  s.email = %q{hello@brightbox.co.uk}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "CHANGELOG",
     "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "lib/rspec_check_auth.rb",
     "lib/rspec_check_auth/check_auth.rb",
     "lib/rspec_check_auth/check_auth/output.rb",
     "lib/rspec_check_auth/check_auth/request.rb",
     "lib/rspec_check_auth/extend_hash.rb",
     "lib/rspec_check_auth/extend_object.rb",
     "spec/rspec_check_auth_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/brightbox/rspec-check-auth}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Quickly check your rails controller actions require authentication}
  s.test_files = [
    "spec/rspec_check_auth_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end