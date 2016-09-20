# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'clearsale/version'

Gem::Specification.new do |s|
  s.name        = 'clearsale'
  s.version     = Clearsale::VERSION
  s.authors     = ['Daniel Konishi']
  s.email       = %w[dkonishi@gmail.com]
  s.homepage    = 'http://github.com/Baby-com-br/clearsale'
  s.summary     = 'clearsale gem to use Clearsale service'
  s.description = 'clearsale gem to use Clearsale service'

  s.rubyforge_project = 'clearsale'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.add_dependency 'builder', '~> 3.2'
  s.add_dependency 'savon', '~> 2.11', '>= 2.11.0'

  s.add_development_dependency 'rake',          '~> 11.2'
  s.add_development_dependency 'rspec',         '~> 3.5'
  s.add_development_dependency 'webmock',       '~> 2.1'
  s.add_development_dependency 'vcr',           '~> 3.0'
  s.add_development_dependency 'guard-rspec',   '~> 4.7'
  s.add_development_dependency 'guard-bundler', '~> 2.1'
  s.add_development_dependency 'byebug',        '~> 9.0'
  s.add_development_dependency 'activesupport', '~> 5.0'
  s.add_development_dependency 'i18n',          '~> 0.7'
  s.add_development_dependency 'curb',          '~> 0.9'
  s.add_development_dependency 'timecop',       '~> 0.8'
  s.add_development_dependency 'psych',         '~> 2.0', '>= 2.0.2'
end
