# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'lib', 'double_agent', 'version')

Gem::Specification.new do |spec|
  spec.name = 'double_agent'
  spec.version = DoubleAgent::VERSION
  spec.summary = "Browser User Agent string parser"
  spec.description = "Browser User Agent string parser with resources, stats, log reader, and graph generator"
  spec.authors = ['Jordan Hollinger']
  spec.date = '2011-11-01'
  spec.email = 'jordan@jordanhollinger.com'
  spec.homepage = 'https://github.com/jhollinger/double_agent'

  spec.require_paths = ['lib']
  spec.extra_rdoc_files = ['README.rdoc', 'CHANGELOG']
  spec.files = [Dir.glob('lib/**/*'), Dir.glob('data/**/*'), Dir.glob('spec/**/*'), 'README.rdoc', 'LICENSE'].flatten

  spec.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION if spec.respond_to? :specification_version
end
