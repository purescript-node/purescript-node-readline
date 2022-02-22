"use strict";

// module Node.ReadLine

export function createInterfaceImpl(options) {
  return function () {
    var readline = require("readline");
    return readline.createInterface({
      input: options.input,
      output: options.output,
      completer:
        options.completer &&
        function (line) {
          var res = options.completer(line)();
          return [res.completions, res.matched];
        },
      terminal: options.terminal,
      historySize: options.historySize,
    });
  };
}

export function close(readline) {
  return function () {
    readline.close();
  };
}

export function prompt(readline) {
  return function () {
    readline.prompt();
  };
}

export function question(text) {
  return function (callback) {
    return function (readline) {
      return function () {
        readline.question(text, function (result) {
          callback(result)();
        });
      };
    };
  };
}

export function setPrompt(prompt) {
  return function (readline) {
    return function () {
      readline.setPrompt(prompt);
    };
  };
}

export function setLineHandler(callback) {
  return function (readline) {
    return function () {
      readline.removeAllListeners("line");
      readline.on("line", function (line) {
        callback(line)();
      });
    };
  };
}
