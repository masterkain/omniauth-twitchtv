# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-twitchtv/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-twitchtv"
  s.version     = Omniauth::Twitchtv::VERSION
  s.authors     = ["Claudio Poli"]
  s.email       = ["claudio@audiobox.fm"]
  s.homepage    = "https://github.com/masterkain/omniauth-twitchtv"
  s.summary     = %q{Twitch.TV strategy for OmniAuth.}
  s.description = %q{Twitch.TV strategy for OmniAuth.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.1'

  s.add_development_dependency 'rspec', '~> 2.7'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rack-test'
end
