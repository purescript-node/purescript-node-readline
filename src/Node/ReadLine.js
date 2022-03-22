// module Node.ReadLine

import { createInterface } from 'readline';

export function createInterfaceImpl(options) {
  return () => createInterface({
    input: options.input,
    output: options.output,
    completer: options.completer && (line => {
        const res = options.completer(line)();
        return [res.completions, res.matched];
    }),
    terminal: options.terminal,
    historySize: options.historySize,
  });
}

export function close(readline) {
  return () => {
    readline.close();
  };
}

export function prompt(readline) {
  return () => {
    readline.prompt();
  };
}

export function question(text) {
  return callback => readline => () => {
    readline.question(text, result => {
      callback(result)();
    });
  };
}

export function setPrompt(prompt) {
  return readline => () => {
    readline.setPrompt(prompt);
  };
}

export function setLineHandler(callback) {
  return readline => () => {
    readline.removeAllListeners("line");
    readline.on("line", line => {
      callback(line)();
    });
  };
}
