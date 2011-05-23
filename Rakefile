#!/usr/bin/env rake

require 'hoe'
Hoe.plugin :gemspec2

Hoe.spec 'micro_fire' do
  developer 'raggi', 'raggi@rubyforge.org'
  extra_dev_deps << %w(hoe-gemspec2 >=1.0.0)

  self.extra_rdoc_files = FileList["**/*.rdoc"]
  self.history_file     = "CHANGELOG.rdoc"
  self.readme_file      = "README.rdoc"
end
