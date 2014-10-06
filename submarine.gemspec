Gem::Specification.new do |s|
  s.name        = 'submarine'
  s.version     = '0.0.1'
  s.date        = '2014-10-05'
  s.summary     = 'Deep sea string substitution.'
  s.description = 'A lightweight string formatter.'
  s.authors     = ['Caleb K Matthiesen']
  s.email       = 'c@calebkm.com'
  s.files       = ['lib/submarine.rb', 'lib/submarine/exceptions.rb', 'lib/submarine/configuration.rb', 'lib/submarine/submarine.rb']
  s.homepage    = 'http://www.submarine-gem.org'
  s.license     = 'MIT'

  s.add_dependency 'facets', '~> 2.9.3'

  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'minitest', '~> 5.4.2'
end