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
ES_LINT = '.eslintrc.json'
STYLE_LINT = '.stylelintrc.json'
COMMIT_LINT = '.commitlintrc.json'

CONFIGS = []

CONFIGS << PACKAGE
CONFIGS << PRETTIER
CONFIGS << NODEMON
CONFIGS << TS_LINT
CONFIGS << TS_CONFIG
CONFIGS << LINT_STAGED
CONFIGS << HUSKY
CONFIGS << ES_LINT
CONFIGS << STYLE_LINT
CONFIGS << COMMIT_LINT

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

def display_header
  puts "\n========================================".blue
  puts "\tInitialize Boilerplate\n"
  puts "========================================\n".blue
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
  input = STDIN.gets.chomp.strip
  process_option(input.to_i)
end

def check_already_init
  if File.file?(PACKAGE)
    puts "#{PACKAGE} exists and will be used".green
  else
    puts "#{PACKAGE} does not exist".green
    system('npm init -y')
    package_json = File.read(PACKAGE)
    package_hash = JSON.parse(package_json)
    package_hash['description'] = 'TODO'
    package_hash['repository'] = 'TODO' unless package_hash.key?('repository')
    File.open(PACKAGE, 'w+') do |file|
      file.write(JSON.pretty_generate(package_hash))
      file.close
    end
  end
end

def check_npm
  return unless system('npm --version').nil?

  puts 'Error: npm is not installed'.red
  exit(1)
end

def create_node_directory
  puts 'Creating src directory...'.green
  path = './src/index.ts'
  dir = File.dirname(path)
  FileUtils.mkdir_p(dir) unless File.directory?(dir)
  File.new(path, 'w+')
end

def configure_nodemon
  puts 'Configuring nodemon...'.green
  if File.exist?(NODEMON)
    return "#{NODEMON} already exists and will not be configured"
  end

  hash = {
    watch: ['src'],
    ext: '.ts,.js',
    ignore: [],
    exec: 'ts-node ./src/index.ts'
  }
  File.open(NODEMON, 'w+') do |file|
    file.truncate(0)
    file.write(JSON.pretty_generate(hash))
    file.close
  end
end

def configure_ts_lint
  puts 'Configuring tslint...'.green
  system('npx tslint --init')
  ts_lint = File.read(TS_LINT)
  ts_lint_hash = JSON.parse(ts_lint)
  if ts_lint_hash.key?('rules') && ts_lint_hash['rules'].is_a?(Hash)
    ts_lint_hash['rules']['no-console'] = false
    ts_lint_hash['rules']['prettier'] = true
  end
  ts_lint_hash['extends'] << 'tslint-config-prettier'
  ts_lint_hash['extends'] << 'tslint-plugin-prettier'
  File.open(TS_LINT, 'w+') do |file|
    file.write(JSON.pretty_generate(ts_lint_hash))
    file.close
  end
end

def update_node_package_json
  puts "Updating #{PACKAGE} scripts...".green
  package_json = File.read(PACKAGE)
  package_hash = JSON.parse(package_json)
  package_hash['scripts']['start:dev'] = 'nodemon'
  package_hash['scripts']['build'] = 'rimraf ./build && tsc'
  package_hash['scripts']['start'] = 'npm run build && node build/index.js'
  File.open(PACKAGE, 'w+') do |file|
    file.write(JSON.pretty_generate(package_hash))
    file.close
  end
end

def configure_prettier
  puts 'Installing and configuring prettier...'.green
  system('npm install --save-dev prettier tslint-config-prettier tslint-plugin-prettier')
  if File.exist?(PRETTIER)
    return "#{PRETTIER} already exists and will not be configured"
  end

  hash = {
    trailingComma: 'es5',
    arrowParens: 'always',
    singleQuote: true,
    printWidth: 120
  }
  File.open(PRETTIER, 'w+') do |file|
    file.write(JSON.pretty_generate(hash))
    file.close
  end
end

def configure_typescript
  create_node_directory
  puts 'Installing and configuring typescript...'.green
  system('npm install --save-dev typescript tslint @types/node ts-node nodemon rimraf @types/express')
  system('npm install express')
  system('npx tsc --init --rootDir src --outDir build --moduleResolution "node" --esModuleInterop --resolveJsonModule --lib esnext --sourceMap --module commonjs --allowJs true --noImplicitAny true --target "esnext"')
end

def configure_eslint(react)
  puts 'Installing and configuring ESLint...'.green
  system('npm install --save-dev eslint eslint-plugin-prettier eslint-config-prettier')
  system('npx eslint --init')
  es_lint = File.read(ES_LINT)
  es_lint_hash = JSON.parse(es_lint)
  es_lint_hash['plugins'] << 'prettier'
  es_lint_hash['rules']['prettier/prettier'] = 'error'
  es_lint_hash['rules']['no-console'] = 1
  es_lint_hash['extends'] << 'prettier'
  es_lint_hash['extends'] << 'plugin:prettier/recommended'
  es_lint_hash['extends'] << 'prettier/react' if react
  File.open(ES_LINT, 'w+') do |file|
    file.write(JSON.pretty_generate(es_lint_hash))
    file.close
  end
end

def install_node_dependencies
  puts 'Installing dev dependencies...'.green
  system('npm install --save-dev husky lint-staged')
end

def configure_stylelint
  puts 'Installing and configuring stylelint...'.green
  system('npm install --save-dev stylelint stylelint-config-standard stylelint-config-sass-guidelines stylelint-prettier stylelint-config-prettier')
  hash = {
    extends: %w[stylelint-config-standard stylelint-config-sass-guidelines stylelint-prettier/recommended],
    plugins: ['stylelint-prettier'],
    rules: {
      'prettier/prettier': true
    }
  }
  File.open(STYLE_LINT, 'w+') do |file|
    file.write(JSON.pretty_generate(hash))
    file.close
  end
end

def configure_commitlint
  puts 'Installing and configuring commitlint...'
  system('npm install --save-dev @commitlint/{config-conventional,cli} stylefmt')
  hash = { extends: ['@commitlint/config-conventional'] }
  File.open(COMMIT_LINT, 'w+') do |file|
    file.write(JSON.pretty_generate(hash))
    file.close
  end
end

def configure_husky
  puts 'Installing and configuring husky with lint-staged...'
  system('npx mrm lint-staged')
  package_json = File.read(PACKAGE)
  package_hash = JSON.parse(package_json)
  package_hash['husky']['hooks']['commit-msg'] = 'commitlint -E HUSKY_GIT_PARAMS'
  git_add = 'git add'
  package_hash['lint-staged'] = {
    '*.+(js|jsx|ts|tsx)': [
      'eslint --cache --fix',
      git_add
    ],
    '*.+(json|css|md|html|ts|tsx|jsx)': [
      'prettier --write',
      git_add
    ],
    '*.+(css|less|sass)': [
      'stylefmt',
      'stylelint --fix',
      git_add
    ]
  }
  File.open(PACKAGE, 'w+') do |file|
    file.write(JSON.pretty_generate(package_hash))
    file.close
  end
end

def create_node_project
  puts 'Creating node.js project'.green
  check_npm
  check_already_init
  install_node_dependencies
  configure_typescript
  configure_nodemon
  configure_ts_lint
  update_node_package_json
  configure_prettier
  configure_eslint(false)
  configure_commitlint
  configure_husky
end

def create_react_project
  puts 'Creating react.js project'
  check_npm
  check_already_init
  system('npx create-react-app .')
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
  puts "\nCleaning directory...".light_blue
  FileUtils.rm_rf 'src' if File.directory?('src')
  CONFIGS.each do |config|
    File.delete(config) if File.exist?(config)
  end
  File.delete('package-lock.json') if File.exist?('package-lock.json')
end

def main
  display_header
  clean_directory if ARGV[0] == 'clean'
  display_menu
end

main