# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'lib', 'double_agent', 'version')

Gem::Specification.new do |spec|
  spec.name = 'double_agent'
  spec.version = DoubleAgent::VERSION
  spec.summary = "Browser User Agent string parser"
  spec.description = "Browser User Agent string parser"
  spec.authors = ['Jordan Hollinger']
  spec.date = '2012-11-10'
  spec.email = 'jordan@jordanhollinger.com'
  spec.homepage = 'https://github.com/jhollinger/double_agent'

  spec.require_paths = ['lib']
  spec.extra_rdoc_files = ['README.rdoc', 'CHANGELOG']
  spec.files = [Dir.glob('lib/**/*'), Dir.glob('data/**/*'), 'README.rdoc', 'LICENSE'].flatten

  spec.specification_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION if spec.respond_to? :specification_version
end
