# Create Boilerplate CLI

## Description

A command line interface tool to create boilerplate for react.js and node.js projects.

Less time setting up the tooling, more time developing.

---
https://rubygems.org/gems/init-boilerplate

![Gem](https://img.shields.io/gem/v/init-boilerplate?style=flat-square)
![Gem](https://img.shields.io/gem/dt/init-boilerplate?style=flat-square)

![GitHub](https://img.shields.io/github/license/gpnn/create-boilerplate-cli?style=flat-square)

![GitHub top language](https://img.shields.io/github/languages/top/gpnn/create-boilerplate-cli?style=flat-square)
![GitHub language count](https://img.shields.io/github/languages/count/gpnn/create-boilerplate-cli?style=flat-square)

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/gpnn/create-boilerplate-cli?style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/gpnn/create-boilerplate-cli?style=flat-square)

## Motivation

Every time I started a project with react.js or node.js, I had to set up a several tooling, such as Prettier, ESLint, etc.

I decided to create a tool for myself that will set those up for me automatically from a few questions.

## Diagram / Screenshot / GIFs

![GIF recording](https://github.com/gpnn/create-boilerplate-cli/blob/master/docs/Screen%20Recording%202020-03-14%20at%206.06.27%20PM.mov.gif?raw=true)

_Note: this GIF is a little bit outdated since I published it as a gem._

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
