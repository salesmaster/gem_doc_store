# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'doc_store/version'

Gem::Specification.new do |gem|
  gem.name          = "doc_store"
  gem.version       = DocStore::VERSION
  gem.authors       = ["Thomas Riboulet"]
  gem.email         = ["riboulet@gmail.com"]
  gem.description   = %q{a simple doc store provider. 
    DocStore object are created with or without content and stored in a
    memcached server.}
  gem.summary       = %q{a simple doc store provider}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = DocStore::VERSION
  gem.add_development_dependency 'rake'
end
