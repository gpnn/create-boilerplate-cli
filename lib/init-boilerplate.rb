require 'fileutils'
require 'json'
require 'colorize'

module InitBoilerplate
  CONFIGS = [
      PACKAGE = 'package.json'.freeze,
      PRETTIER = '.prettierrc'.freeze,
      NODEMON = 'nodemon.json'.freeze,
      TS_CONFIG = 'tsconfig.json'.freeze,
      LINT_STAGED = '.lintstagedrc'.freeze,
      HUSKY = '.huskyrc'.freeze,
      ES_LINT = '.eslintrc.json'.freeze,
      STYLE_LINT = '.stylelintrc.json'.freeze,
      COMMIT_LINT = '.commitlintrc.json'.freeze
  ].freeze

  def self.display_header
    puts "\n========================================".colorize(:blue)
    puts "\tInitialize Boilerplate".colorize(:blue)
    puts "========================================\n".colorize(:blue)
    display_pwd
  end

  def self.display_pwd
    puts "\nThe current working directory is:".colorize(:green)
    puts Dir.pwd.to_s.colorize(:green)
  end

  def self.display_menu
    puts "\n1. Create node.js project".colorize(:blue)
    puts '2. Create react.js project'.colorize(:blue)
    puts '3. Add GitHub templates'.colorize(:blue)
    puts "4. Exit\n".colorize(:blue)
    puts 'Select an option:'.colorize(:yellow)
    input = STDIN.gets.chomp.strip
    process_option(input.to_i)
  end

  def self.check_already_init
    if File.file?(PACKAGE)
      puts "#{PACKAGE} exists and will be used".colorize(:green)
    else
      puts "#{PACKAGE} does not exist".colorize(:green)
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

  def self.check_npm
    puts 'Checking npm...'.colorize(:yellow)
    return unless system('npm --version').nil?

    puts 'Error: npm is not installed'.colorize(:red)
    exit(1)
  end

  def self.create_node_directory(typescript)
    puts 'Creating src directory...'.colorize(:green)
    path = if typescript
             './src/index.ts'
           else
             './src/index.js'
           end
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.directory?(dir)
    File.new(path, 'w+')
  end

  def self.configure_nodemon
    puts 'Configuring nodemon...'.colorize(:green)
    system('npm install --save-dev nodemon')
    return "#{NODEMON} already exists and will not be configured" if File.exist?(NODEMON)

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

  def self.update_node_package_json
    puts "Updating #{PACKAGE} scripts...".colorize(:green)
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

  def self.configure_prettier
    puts 'Installing and configuring prettier...'.colorize(:green)
    system('npm install --save-dev prettier')
    return "#{PRETTIER} already exists and will not be configured" if File.exist?(PRETTIER)

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

  def self.configure_typescript(react)
    puts 'Installing and configuring typescript...'.colorize(:green)
    system('npm install --save-dev typescript @types/node ts-node rimraf')
    if react
      system('npm install --save-dev @types/react @types/react-dom @types/jest')
    else
      system('npm install --save-dev @types/express')
      system('npm install express')
    end
    system('npx tsc --init --rootDir src --outDir build --moduleResolution "node" --esModuleInterop --resolveJsonModule --sourceMap --module commonjs --allowJs true --noImplicitAny true --target "es6"')
  end

  def self.configure_eslint(react)
    puts 'Installing and configuring ESLint...'.colorize(:green)
    system('npm install --save-dev eslint eslint-plugin-prettier eslint-config-prettier')
    system('npx eslint --init')
    es_lint = File.read(ES_LINT)
    es_lint_hash = JSON.parse(es_lint)
    es_lint_hash['plugins'] << 'prettier'
    es_lint_hash['rules']['prettier/prettier'] = 'error'
    es_lint_hash['rules']['no-console'] = 1
    es_lint_hash['extends'] << 'prettier'
    es_lint_hash['extends'] << 'plugin:prettier/recommended'
    if react
      es_lint_hash['plugins'] << 'react'
      es_lint_hash['extends'] << 'plugin:react/recommended'
      es_lint_hash['extends'] << 'prettier/react'
    end
    File.open(ES_LINT, 'w+') do |file|
      file.write(JSON.pretty_generate(es_lint_hash))
      file.close
    end
  end

  def self.configure_stylelint
    puts 'Installing and configuring stylelint...'.colorize(:green)
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

  def self.configure_commitlint
    puts 'Installing and configuring commitlint...'
    system('npm install --save-dev @commitlint/{config-conventional,cli} stylefmt')
    hash = {
        extends: ['@commitlint/config-conventional']
    }
    File.open(COMMIT_LINT, 'w+') do |file|
      file.write(JSON.pretty_generate(hash))
      file.close
    end
  end

  def self.configure_husky
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
        ],
        '*.+(scss)': [
            'stylefmt',
            'stylelint --fix --syntax=scss',
            git_add
        ]
    }
    File.open(PACKAGE, 'w+') do |file|
      file.write(JSON.pretty_generate(package_hash))
      file.close
    end
  end

  def self.create_node_project
    puts 'Does your project use TypeScript? (y/n)'.colorize(:yellow)
    input = STDIN.gets.strip.chomp
    typescript = input == 'y'
    puts 'Make sure this is where you want to create your project (y/n)'.colorize(:magenta)
    display_pwd
    confirm = STDIN.gets.strip.chomp
    exit(0) if confirm != 'y'
    puts 'Creating node.js project'.colorize(:green)
    puts 'With TypeScript' if typescript
    check_npm
    check_already_init
    configure_typescript(false) if typescript
    create_node_directory(typescript)
    configure_nodemon
    update_node_package_json
    configure_prettier
    configure_eslint(false)
    configure_commitlint
    configure_husky
  end

  def self.create_react_project
    puts 'Does your project use TypeScript? (y/n)'.colorize(:yellow)
    input = STDIN.gets.strip.chomp
    typescript = input == 'y'
    puts 'Make sure this is where you want to create your project (y/n)'.colorize(:magenta)
    display_pwd
    confirm = STDIN.gets.strip.chomp
    exit(0) if confirm != 'y'
    puts 'Creating react.js project'.colorize(:green)
    puts 'With TypeScript' if typescript
    check_npm
    check_already_init
    if typescript
      configure_typescript(true)
      system('npx create-react-app . --template typescript')
    else
      system('npx create-react-app .')
    end
    configure_prettier
    configure_eslint(true)
    configure_commitlint
    configure_husky
  end

  def self.add_templates
    # TODO
  end

  def self.process_option(choice)
    case choice
    when 4
      puts "\nExiting...".colorize(:green)
      exit(0)
    when 3
      add_templates
    when 2
      create_react_project
    when 1
      create_node_project
    else
      puts "\nYour input is invalid, returning to menu..."
      display_menu
    end
  end

  def self.clean_directory
    puts "\nCleaning directory...".colorize(:blue)
    FileUtils.rm_rf 'src' if File.directory?('src')
    CONFIGS.each do |config|
      File.delete(config) if File.exist?(config)
    end
    File.delete('package-lock.json') if File.exist?('package-lock.json')
  end

  def self.main
    display_header
    clean_directory if ARGV[0] == 'clean'
    display_menu
  end
end