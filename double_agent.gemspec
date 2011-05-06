# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name = 'double_agent'
  spec.version = '0.0.3'
  spec.summary = "Browser User Agent string parser"
  spec.description = "Browser User Agent string parser with resource, stats, and a log reader"
  spec.authors = ['Jordan Hollinger']
  spec.date = '2011-04-30'
  spec.email = 'jordan@jordanhollinger.com'
  spec.homepage = 'http://github.com/jhollinger/double_agent'

  spec.require_paths = ['lib']
  spec.extra_rdoc_files = ['README.rdoc', 'CHANGELOG']
  spec.files = [Dir.glob('lib/**/*'), Dir.glob('data/**/*'), Dir.glob('spec/**/*'), 'README.rdoc', 'LICENSE'].flatten

  spec.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION if spec.respond_to? :specification_version
end
