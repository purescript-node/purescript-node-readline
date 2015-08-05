/* global exports */
"use strict";

// module Node.ReadLine

exports.setLineHandler = function(readline) {
    return function(callback) {
        return function() {
            readline.removeAllListeners('line');
            readline.on('line', function(line) {
                callback(line)();
            });
            return readline;
        };
    };
};

exports.prompt = function(readline) {
    return function() {
        readline.prompt();
        return readline;
    };
};

exports.setPrompt = function(prompt) {
    return function(length) {
        return function(readline) {
            return function() {
                readline.setPrompt(prompt, length);
                return readline;
            };
        };
    };
};

exports.createInterface = function(completer) {
    return function() {
        var readline = require('readline');
        return readline.createInterface({
            input: process.stdin,
            output: process.stdout,
            completer: function(line) {
                var res = completer(line)();
                return [res.completions, res.suffix];
            }
        });
    };
};
