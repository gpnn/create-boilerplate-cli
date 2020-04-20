# Create Boilerplate CLI

## Description

A command line interface tool to create boilerplate for react.js and node.js projects.

Less time setting up the tooling, more time developing.

---
[![RubyGem version](https://badgen.net/rubygems/v/init-boilerplate/latest)](https://rubygems.org/gems/init-boilerplate)
[![RubyGem downloads](https://badgen.net/rubygems/dt/init-boilerplate)](https://rubygems.org/gems/init-boilerplate)
![Last commit](https://badgen.net/github/last-commit/gordonpn/create-boilerplate-cli)
![License](https://badgen.net/github/license/gordonpn/create-boilerplate-cli)

## Motivation

Every time I started a project with react.js or node.js, I had to set up a several tooling, such as Prettier, ESLint, etc.

I decided to create a tool for myself that will set those up for me automatically from a few questions.

## Diagram / Screenshot / GIFs

[![asciicast](https://asciinema.org/a/4UemVZE29SWWrfV9Nt2jSo2n2.svg)](https://asciinema.org/a/4UemVZE29SWWrfV9Nt2jSo2n2)

## Features

- Supports react.js and node.js projects, with or without TypeScript
- Sets up ESLint, Prettier while taking into account for TypeScript
- stylefmt and stylelint
- Sets up Husky pre-commit and commit message hooks
- Sets up lint-staged
- Sets up nodemon for node.js projects

## Getting started

The script is written in Ruby, simply because it is enjoyable to write with and it comes pre-installed on macOS (my OS of preference).

### Prerequisites

Must have the following installed:

- Ruby >= 2.6
- NPM >= 5.2.0

### Configuration

Run the command and answer the prompts.

### Installing

```bash
gem install init-boilerplate
```

### Usage

Navigate to a fresh directory where you want to start your project and run the following command.

```bash
init-boilerplate
```

## Roadmap

- [x] Add Git boilerplate
  - README outline, templates, etc.
- [x] Create and publish Ruby Gem

## License

[MIT License](https://opensource.org/licenses/MIT)
