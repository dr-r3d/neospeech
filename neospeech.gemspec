# -*- encoding: utf-8 -*-
require File.expand_path('../lib/neospeech/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Abhishek Anand"]
  gem.email         = ["r3d.d7a90n@gmail.com"]
  gem.description   = %q{Ruby wrapper for NeoSpeech Text to Speech API}
  gem.summary       = %q{Ruby wrapper for NeoSpeech Text to Speech API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "neospeech"
  gem.require_paths = ["lib"]
  gem.version       = Neospeech::VERSION
  gem.add_runtime_dependency 'httparty'
  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'builder'
end
