# Elm App Boilerplate

[![Run Status](https://api.shippable.com/projects/572133332a8192902e1e2958/badge?branch=master)](https://app.shippable.com/projects/572133332a8192902e1e2958)

Provides an efficient development workflow and a starting point for building Elm applications.

## Features

- automated build of all application resources using [webpack](http://webpack.github.io/)
- Hot Module Replacement for the Elm code using [elm-hot-loader](https://github.com/fluxxu/elm-hot-loader)
- automatic re-execution of tests on source change for Elm and JavaScript code
- property based testing using [elm-check](https://github.com/NoRedInk/elm-check) for the Elm tests
- test coverage using [istanbul](https://github.com/gotwarlost/istanbul) for the JavaScript tests
- [Semantic UI](http://semantic-ui.com/) integration
- JavaScript code written in ES6, transpiled using [Babel](https://babeljs.io/)
- JavaScript linted using [eslint](http://eslint.org/)
- building and running a [Docker](https://www.docker.com/) image

## Getting Started

Fork and clone this repo.

```
npm install
npm start
```

Open `http://localhost:8080/` in a browser.

## Preparing for Deployment

Building the application (build artifacts ready for deployment are stored in `./dist`).

```
npm run build
```

Creating a docker image containing a copy of the `./dist` directory and served by [nginx](https://www.nginx.com/) on port 80. Requires Docker version 1.11.1 or later.

```
npm run docker-build
```

Testing the created docker image.

```
npm run docker-run # creates and starts a Docker container
# the app is now available at http://localhost:8081

npm run docker-start # starts an existing container
npm run docker-stop # stops an existing container
npm run docker-rm # removes an existing, stopped container
```


## Testing

Run tests once off

```
npm test # Elm and JavaScript tests
npm run test:elm # only Elm tests
npm run test:js # only JavaScript tests
```

Restart the tests on code change

```
npm run tdd # Elm and JavaScript tests
npm run tdd:elm # only Elm tests
npm run tdd:js # only JavaScript tests
```

## Updating Version

Use the standard `npm version` command. This project contains npm scripts which also:

- update the version in `elm-package.json`
- push the branch on which the version change was made
- push the created tag

## Elm Commands

The following Elm commands are exposed through npm scripts:

- `npm run elm-reactor`
- `npm run elm-repl`
- `npm run elm-package`
- `npm run elm-make`
- `npm run elm-test`

The parameters to those commands must be specified after `--`, for example: `npm run elm-package -- install evancz/elm-effects`. See [npm run-script](https://docs.npmjs.com/cli/run-script).

## Directory Structure

### General

- `package.json` - defines dependencies and scripts for building, testing and running the application
- `dist/` - built application artifacts produced by `npm run build`
- `coverage/` - JavaScript test coverage reports

### Elm

- `elm-package.json` - describes the Elm application and its dependencies
- `elm/` - Elm source files
- `elm/Main.elm` - Elm application entry point
- `elm/App/` - the namespace for all application Elm modules
- `elm-test/` - directory containing all Elm tests
- `elm-test/TestRunner.elm` - the entry point for executing tests and bootstrapping the actual test runner
- `elm-test/Tests.elm` - the main file loading and exposing all the test suites

### Semantic UI

- `styles/` - all the application styles
- `styles/theme.config` - specifies which theme to use for each components
- `styles/site/` - project-specific configuration and overrides

The following files and directories are copied from `semantic-ui-less` node module by the `postinstall` script and should not be modified manually.

- `styles/definitions/` - Semantic UI component definitions
- `styles/themes/` - Semantic UI themes
- `styles/semantic.less` - includes all Semantic UI components
- `styles/theme.less` - internal theme loading helper

### JavaScript

- `js/` - contains all application JavaScript code
- `js/main.js` - entry point to the application JavaScript code
- `js/semantic-ui/` - scripts for Semantic UI integration
- `js-test/` - directory containing all JavaScript tests
- `js-test/test.js` - entry point for JavaScript tests - automatically loads all `*.test.js` files in `js-test`

### HTML

- `html/index.html` - overall application entry point


## Semantic UI

Semantic UI provides a lot of ready-made, customizable UI components and helps to implement the design of the application quickly and consistently. It was included in `elm-app-boilerplate` because it integrates nicely with Elm.

The main idea behind the integration is that Elm handles all the application logic, integration with the backend and rendering of the HTML. Semantic UI on the other hand is responsible for making the application look nice on the screen.

### Integration

Semantic UI `globals`, `views`, `collections` and `elements` are defined using LESS only (except for `globals/site.js` which handles the global configuration), so they work seamlessly with Elm out of the box.

The `modules` require some JavaScript to work and must be initialized by the application. However, some (if not all) `modules` can be automatically managed in JavaScript in a way that is completely transparent to the Elm code. The demo page of `elm-app-boilerplate` contains some examples of that technique. _Pull requests with examples for other `modules` welcome!_

The `behaviors` would certainly be the most difficult to integrate, however, they are probably also the least likely to be useful to an Elm application. Specifically, the interaction with the backend (`API` behaviour) is better handled in Elm. `Form validation` could be useful, however, [Elm validation](https://github.com/etaque/elm-simple-form) is also available. The `visibility` behaviour is the one which cannot be easily done in Elm, so the integration might be worth the effort.

### Usage

The application can be styled using the following techniques, in order of preference:

1. Select suitable themes for the components by modifying `styles/theme.config`.
2. Configure the Semantic UI variables in `styles/site/**/*.variables`.
3. Add custom LESS code to modify some components in `styles/site/**/*.overrides`.
4. Add any other custom LESS code to `styles/site/globals/site.overrides`, or to custom `*.less` files it imports.

Please refer to [Semantic UI](http://semantic-ui.com/) documentation for more details, including defining your own reusable themes.
