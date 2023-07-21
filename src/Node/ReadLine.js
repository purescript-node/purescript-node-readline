// module Node.ReadLine

import { createInterface } from "readline";

export const createInterfaceImpl = (options) => createInterface({
  input: options.input,
  output: options.output,
  completer: options.completer && (line => {
    const res = options.completer(line)();
    return [res.completions, res.matched];
  }),
  terminal: options.terminal,
  historySize: options.historySize,
});

export const closeImpl = (readline) => readline.close();
export const promptImpl = (readline) => readline.prompt();
export const questionImpl = (readline, text, cb) => readline.question(text, cb);
export const setPromptImpl = (readline, prompt) => readline.setPrompt(prompt);
