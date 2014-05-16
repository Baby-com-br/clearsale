# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "clearsale/version"

Gem::Specification.new do |s|
  s.name        = "clearsale"
  s.version     = Clearsale::VERSION
  s.authors     = ["Daniel Konishi"]
  s.email       = %w[dkonishi@gmail.com]
  s.homepage    = "http://github.com/Baby-com-br/clearsale"
  s.summary     = "clearsale gem to use Clearsale service"
  s.description = "clearsale gem to use Clearsale service"

  s.rubyforge_project = "clearsale"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "builder"
  s.add_dependency "savon", "~> 2.3.2"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "webmock"       , "~> 1.7.0"
  s.add_development_dependency "vcr"           , "~> 1.11.3"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "guard-bundler"
  s.add_development_dependency "debugger"      , ">= 1.6.5"
  s.add_development_dependency "activesupport"
  s.add_development_dependency "i18n"
  s.add_development_dependency "curb"
  s.add_development_dependency "timecop"
  s.add_development_dependency "psych"         , "~> 2.0.2"
end
