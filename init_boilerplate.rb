# frozen_string_literal: true

require 'fileutils'
require 'json'

PACKAGE = 'package.json'
PRETTIER = '.prettierrc'
NODEMON = 'nodemon.json'
TS_LINT = 'tslint.json'
TS_CONFIG = 'tsconfig.json'
LINT_STAGED = '.lintstagedrc'
HUSKY = '.huskyrc'

CONFIGS = []

CONFIGS << PACKAGE
CONFIGS << PRETTIER
CONFIGS << NODEMON
CONFIGS << TS_LINT
CONFIGS << TS_CONFIG
CONFIGS << LINT_STAGED
CONFIGS << HUSKY

def display_header
  puts "\n========================================"
  puts "\tInitialize Boilerplate\n"
  puts "========================================\n"
  puts "\nThe current working directory is:\n"
  puts Dir.pwd
end

def display_menu
  puts "\nSelect an option:\n"
  puts "1. Create node.js project\n"
  puts "2. Create react.js project\n"
  puts "3. Add GitHub templates\n"
  puts "4. Exit\n\n"
  puts 'Your choice: '
  input = gets.chomp.strip
  process_option(input.to_i)
end

def create_react_project
  check_npm
  check_already_init
  system('npx create-react-app .')
end

def check_already_init
  if File.file?(PACKAGE)
    puts "#{PACKAGE} exists and will be used"
  else
    puts "#{PACKAGE} does not exist"
    system('npm init -y')
  end
end

def check_npm
  return unless system('npm --version').nil?

  puts 'Error: npm is not installed'
  exit(1)
end

def create_node_directory
  path = './src/index.ts'
  dir = File.dirname(path)
  FileUtils.mkdir_p(dir) unless File.directory?(dir)
  File.new(path, 'w')
end

def configure_nodemon
  puts 'Configuring nodemon...'
  if File.exist?(NODEMON)
    return "#{NODEMON} already exists and will not be configured"
  end

  hash = {
      watch: ['src'],
      ext: '.ts,.js',
      ignore: [],
      exec: 'ts-node ./src/index.ts'
  }
  File.open(NODEMON, 'w') do |file|
    file.write(JSON.pretty_generate(hash))
  end
end

def configure_ts_lint
  puts 'Configuring tslint...'
  # system('npx tslint --init')
  ts_lint = File.read(TS_LINT)
  ts_lint_hash = JSON.parse(ts_lint)
  if ts_lint_hash.key?('rules') && ts_lint_hash['rules'].is_a?(Hash)
    ts_lint_hash['rules']['no-console'] = false
  end
  File.delete(TS_LINT)
  File.open(TS_LINT, 'w') do |file|
    file.write(JSON.pretty_generate(ts_lint_hash))
  end
end

def update_node_package_json
  package_json = File.read(PACKAGE)
  package_hash = JSON.parse(package_json)
  package_hash['scripts']['start:dev'] = 'nodemon'
  package_hash['scripts']['build'] = 'rimraf ./build && tsc'
  package_hash['scripts']['start'] = 'npm run build && node build/index.js'
  File.delete(PACKAGE)
  File.open(PACKAGE, 'w') do |file|
    file.write(JSON.pretty_generate(package_hash))
  end
end

def configure_prettier
  puts 'Installing and configuring prettier...'
  system('npm install --save-dev prettier')
  if File.exist?(PRETTIER)
    return "#{PRETTIER} already exists and will not be configured"
  end

  hash = {
      trailingComma: 'es5',
      arrowParens: 'always',
      singleQuote: true
  }
  File.open(PRETTIER, 'w') do |file|
    file.write(JSON.pretty_generate(hash))
  end
end

def configure_typescript
  create_node_directory
  puts 'Installing and configuring typescript...'
  # system('npm install --save-dev typescript tslint @types/node \
  #   ts-node nodemon rimraf @types/express')
  # system('npm install express')
  configure_nodemon
  # system('npx tsc --init --rootDir src --outDir build --moduleResolution "node" \
  #   --esModuleInterop --resolveJsonModule --lib esnext --sourceMap \
  #   --module commonjs --allowJs true --noImplicitAny true --target "esnext"')
  # configure_ts_lint
  update_node_package_json
  configure_prettier
end

def install_node_dependencies
  puts 'Installing dev dependencies...'
  # system('npm install --save-dev eslint husky lint-staged commitlint stylelint')
  configure_typescript
end

def create_node_project
  puts 'Creating node.js project'
  check_npm
  check_already_init
  install_node_dependencies
end

def add_templates
  # code here
end

def process_option(choice)
  case choice
  when 4
    puts "\nExiting..."
    exit(0)
  when 3
    puts "\nAdd GitHub templates"
    add_templates
  when 2
    puts "\nCreate react.js project"
    create_react_project
  when 1
    puts "\nCreate node.js project"
    create_node_project
  else
    puts "\nYour input is invalid, returning to menu..."
    display_menu
  end
end

def clean_directory
  puts "\nCleaning directory..."
  FileUtils.rm_rf 'src' if File.directory?('src')
  CONFIGS.each do |config|
    File.delete(config) if File.exist?(config)
  end
  File.delete('package-lock.json') if File.exist?('package-lock.json')
end

def main
  display_header
  if ARGV[0] == 'clean'
    clean_directory
  else
    display_menu
  end
end

main