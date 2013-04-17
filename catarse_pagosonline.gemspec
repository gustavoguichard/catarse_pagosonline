$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "catarse_pagosonline/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "catarse_pagosonline"
  s.version     = CatarsePagosonline::VERSION
  s.authors     = ["Gustavo Guichard"]
  s.email       = ["gustavoguichard@gmail.com"]
  s.homepage    = "http://github.com/gustavoguichard/catarse_pagosonline"
  s.summary     = "Pagosonline integration with Catarse"
  s.description = "Pagosonline integration with Catarse crowdfunding platform"

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency "rails", "~> 3.2.6"
  s.add_dependency "pagosonline"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
end
