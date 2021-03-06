# Changelog

Notable changes to this project are documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

Breaking changes:

New features:

Bugfixes:

Other improvements:

## [v5.0.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v5.0.0) - 2021-02-26

Breaking changes:
  - Added support for PureScript 0.14 and dropped support for all previous versions (#20)
  - Removed length parameter for `setPrompt` (#21)
  - Ensured a consistent argument position for functions using `Interface` (#23)

Other improvements:
  - Migrated CI to GitHub Actions and updated installation instructions to use Spago (#19)
  - Added a changelog and pull request template (#22)

## [v4.0.1](https://github.com/purescript-node/purescript-node-readline/releases/tag/v4.0.1) - 2019-06-08

- Relax upper bounds to allow building with 0.13. (@klntsky)

## [v4.0.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v4.0.0) - 2018-05-29

- Updates for 0.12

## [v3.1.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v3.1.0) - 2017-08-22

- Add `question` (@dgendill)

## [v3.0.1](https://github.com/purescript-node/purescript-node-readline/releases/tag/v3.0.1) - 2017-08-04

- Relax the upper bound in `bower.json` on `node-process`, so that this library can be depended on together with version 5.0.0 of `node-process` without any hassle.

## [v3.0.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v3.0.0) - 2017-04-05

- Updates for 0.11 compiler

## [v2.0.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v2.0.0) - 2016-10-22

- Updated dependencies

## [v1.0.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v1.0.0) - 2016-06-13

- Updates for 0.9.1 compiler (@kika)

## [v0.4.1](https://github.com/purescript-node/purescript-node-readline/releases/tag/v0.4.1) - 2016-03-07

- Fix a bug with completers (@Thimoteus)

## [v0.4.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v0.4.0) - 2016-02-27

- Expose more of the node API (@spicydonuts, #4)

## [v0.3.1](https://github.com/purescript-node/purescript-node-readline/releases/tag/v0.3.1) - 2015-08-10

- Add `close` (@aspidites)

## [v0.3.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v0.3.0) - 2015-08-05

- Flip arguments to `setLineHandler` (@aspidites)

## [v0.2.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v0.2.0) - 2015-07-14

- Release for 0.7 compiler.

## [v0.1.1](https://github.com/purescript-node/purescript-node-readline/releases/tag/v0.1.1) - 2014-10-29

- Prevent row subtraction wonkiness in setLineHandler.

## [v0.1.1](https://github.com/purescript-node/purescript-node-readline/releases/tag/v0.1.1) - 2014-08-27

- Simplify some type signatures, provide default completion, and provide better handling of events.

## [v0.1.0](https://github.com/purescript-node/purescript-node-readline/releases/tag/v0.1.0) - 2014-06-14

- Initial release

