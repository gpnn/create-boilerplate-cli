require './Rakefile'

Gem::Specification.new do |s|
  s.name = 'init-boilerplate'
  s.version = GEM_VERSION
  s.date = '2020-03-18'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Generate boilerplate code for node.js and react.js projects, with all the necessary tooling'
  s.description = 'Supports react.js and node.js projects, with or without TypeScript. Sets up ESLint, Prettier while taking into account for TypeScript. stylefmt and stylelint. Sets up Husky pre-commit and commit message hooks. Sets up lint-staged. Sets up nodemon for node.js projects'
  s.authors = ['Gordon Pham-Nguyen']
  s.email = 'gordon.pn6@gmail.com'
  s.files = Dir.glob('{lib,bin}/**/*')
  s.require_path = 'lib'
  s.homepage = 'https://github.com/gpnn/create-boilerplate-cli/'
  s.license = 'MIT'
  s.add_runtime_dependency 'colorize'
  s.add_runtime_dependency 'down'
  s.add_development_dependency 'colorize'
  s.add_development_dependency 'down'
  s.executables = ['init-boilerplate']
end