GEM_NAME = 'init-boilerplate'.freeze
GEM_VERSION = '0.1.2'.freeze

task default: :build

task :build do
  system 'gem build ' + GEM_NAME + '.gemspec'
end

task install: :build do
  system 'gem install ' + GEM_NAME + '-' + GEM_VERSION + '.gem'
end

task publish: :build do
  system 'gem push ' + GEM_NAME + '-' + GEM_VERSION + '.gem'
end

task :clean do
  system 'rm *.gem'
end
