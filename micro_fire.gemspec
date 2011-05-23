# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{micro_fire}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["raggi"]
  s.date = %q{2011-05-23}
  s.description = %q{A micro single room Campfire interface that only depends on Net::HTTP::Persistent and a JSON library. On 1.9, it will use Psych by default, on other rubies it will try for yajl, then for json.}
  s.email = ["raggi@rubyforge.org"]
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.rdoc", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "lib/micro_fire.rb"]
  s.homepage = %q{http://rubygems.org/gems/micro_fire}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{micro_fire}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{A micro single room Campfire interface that only depends on Net::HTTP::Persistent and a JSON library}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe-gemspec2>, [">= 1.0.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.8.0"])
    else
      s.add_dependency(%q<hoe-gemspec2>, [">= 1.0.0"])
      s.add_dependency(%q<hoe>, [">= 2.8.0"])
    end
  else
    s.add_dependency(%q<hoe-gemspec2>, [">= 1.0.0"])
    s.add_dependency(%q<hoe>, [">= 2.8.0"])
  end
end
