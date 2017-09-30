Gem::Specification.new do |s|
  s.name        = 'tree_concern'
  s.version     = '0.0.0'
  s.date        = '2017-09-30'
  s.summary     = "Tree concern for rails models"
  s.description = "A tree concern for rails models. The Tree concern adds :parent and :children relationships and validates that these remain a tree. It provides multiple ways of querying ancestors and descendants."
  s.authors     = ["Cedric Shock"]
  s.files       = Dir['lib/**/*']
  s.homepage    = 'https://github.com/Cedev/tree_concern'
  s.license     = 'MIT'
end