# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'fluent-plugin-flat-json-parser'
  gem.version     = '0.0.5'
  gem.authors     = ['Stephen Gran']
  gem.email       = 'steve@lobefin.net'
  gem.homepage    = 'https://github.com/sgran/fluent-plugin-flat-json-parser'
  gem.description = 'fluentd parser plugin to flatten nested json objects'
  gem.summary     = gem.description
  gem.licenses    = ['MIT']
  gem.has_rdoc    = false

  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'fluentd', '~> 0.10.17'
  gem.add_development_dependency 'rake'
end
