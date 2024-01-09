// module Node.rl

import readline from "node:readline";

export const createInterfaceImpl = (options) => readline.createInterface({
  input: options.input,
  output: options.output,
  completer: options.completer && (line => {
    const res = options.completer(line)();
    return [res.completions, res.matched];
  }),
  terminal: options.terminal,
  history: options.history,
  historySize: options.historySize,
  removeHistoryDuplicates: options.removeHistoryDuplicates,
  prompt: options.prompt,
  crlfDelay: options.crlfDelay,
  escapeCodeTimeout: options.escapeCodeTimeout,
  tabSize: options.tabSize,
  signal: options.signal
});

export const closeImpl = (rl) => rl.close();
export const pauseImpl = (rl) => rl.pause();
export const promptImpl = (rl) => rl.prompt();
export const promptOptsImpl = (rl, cursor) => rl.prompt(cursor);
export const questionImpl = (rl, text, cb) => rl.question(text, cb);
export const questionOptsCbImpl = (rl, text, opts, cb) => rl.question(text, opts, cb);
export const resumeImpl = (rl) => rl.resume();
export const setPromptImpl = (rl, prompt) => rl.setPrompt(prompt);
export const getPromptImpl = (rl) => rl.getPrompt();
export const writeDataImpl = (rl, dataStr) => rl.write(dataStr);
export const writeKeyImpl = (rl, keySeqObj) => rl.write(null, keySeqObj);
export const lineImpl = (rl) => rl.line;
export const cursorImpl = (rl) => rl.cursor;
export const getCursorPosImpl = (rl) => rl.getCursorPos();

export const clearLineLeftImpl = (w) => readline.clearLine(w, -1);
export const clearLineLeftCbImpl = (w, cb) => readline.clearLine(w, -1, cb);
export const clearLineRightImpl = (w) => readline.clearLine(w, 1);
export const clearLineRightCbImpl = (w, cb) => readline.clearLine(w, 1, cb);
export const clearEntireLineImpl = (w) => readline.clearLine(w, 0);
export const clearEntireLineCbImpl = (w, cb) => readline.clearLine(w, 0, cb);
export const clearScreenDownImpl = (w) => readline.clearScreenDown(w);
export const clearScreenDownCbImpl = (w, cb) => readline.clearScreenDown(w, cb);
export const cursorToXImpl = (w, x) => readline.cursorTo(w, x);
export const cursorToXCbImpl = (w, x, cb) => readline.cursorTo(w, x, cb);
export const cursorToXYImpl = (w, x, y) => readline.cursorTo(w, x, y);
export const cursorToXYCbImpl = (w, x, y, cb) => readline.cursorTo(w, x, y, cb);
export const emitKeyPressEventsImpl = (r) => readline.emitKeypressEvents(r);
export const emitKeyPressEventsIfaceImpl = (r, iface) => readline.emitKeypressEvents(r, iface);
export const moveCursorXYImpl = (w, x, y) => readline.moveCursor(w, x, y);
export const moveCursorXYCbImpl = (w, x, y, cb) => readline.moveCursor(w, x, y, cb);
