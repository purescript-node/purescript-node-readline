/* global exports */
'use strict';

// module Node.ReadLine

exports.createInterfaceImpl = function (options) {
    return function () {
        var readline = require('readline');
        return readline.createInterface(
            { input: options.input
      , output: options.output
      , completer: options.completer && function (line) {
          var res = options.completer(line)();
          return [res.completions, res.matched];
      }
      , terminal: options.terminal
      , historySize: options.historySize
            });
    };
};

exports.close = function (readline) {
    return function () {
        readline.close();
    };
};

exports.prompt = function (readline) {
    return function () {
        readline.prompt();
    };
};

exports.setPrompt = function (prompt) {
    return function (length) {
        return function (readline) {
            return function () {
                readline.setPrompt(prompt, length);
            };
        };
    };
};

exports.setLineHandler = function (readline) {
    return function (callback) {
        return function () {
            readline.removeAllListeners('line');
            readline.on('line', function (line) {
                callback(line)();
            });
        };
    };
};
