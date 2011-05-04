# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name = 'double_agent'
  spec.version = '0.0.1'
  spec.summary = "Browser User Agent string parser with stats"
  spec.authors = ['Jordan Hollinger']
  spec.date = '2011-04-30'
  spec.email = 'jordan@jordanhollinger.com'

  spec.require_paths = ['lib']
  spec.files = [Dir.glob('lib/**/*'), Dir.glob('data/**/*'), 'LICENSE'].flatten

  spec.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION if spec.respond_to? :specification_version
end
