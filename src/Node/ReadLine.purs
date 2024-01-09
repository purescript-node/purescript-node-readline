-- | This module provides a binding to the Node `readline` API.

module Node.ReadLine
  ( Interface
  , toEventEmitter
  , createInterface
  , createConsoleInterface
  , InterfaceOptions
  , output
  , Completer
  , completer
  , noCompletion
  , terminal
  , history
  , historySize
  , removeHistoryDuplicates
  , promptStr
  , crlfDelay
  , escapeCodeTimeout
  , tabSize
  , signal
  , closeH
  , lineH
  , historyH
  , pauseH
  , resumeH
  , sigContH
  , sigIntH
  , sigStpH
  , close
  , pause
  , prompt
  , prompt'
  , question
  , question'
  , resume
  , setPrompt
  , getPrompt
  , writeData
  , writeKey
  , line
  , cursor
  , getCursorPos
  , clearLineLeft
  , clearLineLeft'
  , clearLineRight
  , clearLineRight'
  , clearEntireLine
  , clearEntireLine'
  , clearScreenDown
  , clearScreenDown'
  , cursorToX
  , cursorToX'
  , cursorToXY
  , cursorToXY'
  , emitKeyPressEvents
  , emitKeyPressEvents'
  , moveCursorXY
  , moveCursorXY'
  ) where

import Prelude

import Data.Options (Options, Option, (:=), options, opt)
import Data.Time.Duration (Milliseconds)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, mkEffectFn1, runEffectFn1, runEffectFn2, runEffectFn3, runEffectFn4)
import Foreign (Foreign)
import Node.Errors.AbortSignal (AbortSignal)
import Node.EventEmitter (EventEmitter, EventHandle(..))
import Node.EventEmitter.UtilTypes (EventHandle0, EventHandle1)
import Node.Process (stdin, stdout)
import Node.Stream (Readable, Writable)
import Unsafe.Coerce (unsafeCoerce)

-- | A handle to a console interface.
-- |
-- | A handle can be created with the `createInterface` function.
-- |
-- | `Interface` extends `EventEmiter`
-- |
-- | From Node docs v18:
-- | > Instances of the `readline.Interface` class are constructed using the `readline.createInterface()` method. 
-- | > Every instance is associated with a single input Readable stream and a single output Writable stream. 
-- | > The output stream is used to print prompts for user input that arrives on, and is read from, the input stream.
foreign import data Interface :: Type

toEventEmitter :: Interface -> EventEmitter
toEventEmitter = unsafeCoerce

-- | Builds an interface with the specified options.
-- | The `Readable` arg to this function
-- | will be used as the `input` option below:
-- |
-- | - `input` <stream.Readable> The Readable stream to listen to. This option is required.
-- | - `output` <stream.Writable> The Writable stream to write readline data to.
-- | - `completer` <Function> An optional function used for Tab autocompletion.
-- | - `terminal` <boolean> true if the input and output streams should be treated like a TTY, and have ANSI/VT100 escape codes written to it. Default: checking isTTY on the output stream upon instantiation.
-- | - `history` <string[]> Initial list of history lines. This option makes sense only if terminal is set to true by the user or by an internal output check, otherwise the history caching mechanism is not initialized at all. Default: [].
-- | - `historySize` <number> Maximum number of history lines retained. To disable the history set this value to 0. This option makes sense only if terminal is set to true by the user or by an internal output check, otherwise the history caching mechanism is not initialized at all. Default: 30.
-- | - `removeHistoryDuplicates` <boolean> If true, when a new input line added to the history list duplicates an older one, this removes the older line from the list. Default: false.
-- | - `prompt` <string> The prompt string to use. Default: '> '.
-- | - `crlfDelay` <number> If the delay between \r and \n exceeds crlfDelay milliseconds, both \r and \n will be treated as separate end-of-line input. crlfDelay will be coerced to a number no less than 100. It can be set to Infinity, in which case \r followed by \n will always be considered a single newline (which may be reasonable for reading files with \r\n line delimiter). Default: 100.
-- | - `escapeCodeTimeout` <number> The duration readline will wait for a character (when reading an ambiguous key sequence in milliseconds one that can both form a complete key sequence using the input read so far and can take additional input to complete a longer key sequence). Default: 500.
-- | - `tabSize` <integer> The number of spaces a tab is equal to (minimum 1). Default: 8.
-- | - `signal` <AbortSignal> Allows closing the interface using an AbortSignal. Aborting the signal will internally call close on the interface.
createInterface
  :: forall r
   . Readable r
  -> Options InterfaceOptions
  -> Effect Interface
createInterface input opts = runEffectFn1 createInterfaceImpl
  $ options
  $ opts
      <> opt "input" := input

foreign import createInterfaceImpl :: EffectFn1 Foreign Interface

-- | Create an interface with the specified completion function.
createConsoleInterface :: Completer -> Effect Interface
createConsoleInterface compl =
  createInterface stdin
    $ output := stdout
        <> completer := compl

-- | Options passed to `readline`'s `createInterface`
-- |
-- | - `input` <stream.Readable> The Readable stream to listen to. This option is required.
-- | - `output` <stream.Writable> The Writable stream to write readline data to.
-- | - `completer` <Function> An optional function used for Tab autocompletion.
-- | - `terminal` <boolean> true if the input and output streams should be treated like a TTY, and have ANSI/VT100 escape codes written to it. Default: checking isTTY on the output stream upon instantiation.
-- | - `history` <string[]> Initial list of history lines. This option makes sense only if terminal is set to true by the user or by an internal output check, otherwise the history caching mechanism is not initialized at all. Default: [].
-- | - `historySize` <number> Maximum number of history lines retained. To disable the history set this value to 0. This option makes sense only if terminal is set to true by the user or by an internal output check, otherwise the history caching mechanism is not initialized at all. Default: 30.
-- | - `removeHistoryDuplicates` <boolean> If true, when a new input line added to the history list duplicates an older one, this removes the older line from the list. Default: false.
-- | - `prompt` <string> The prompt string to use. Default: '> '.
-- | - `crlfDelay` <number> If the delay between \r and \n exceeds crlfDelay milliseconds, both \r and \n will be treated as separate end-of-line input. crlfDelay will be coerced to a number no less than 100. It can be set to Infinity, in which case \r followed by \n will always be considered a single newline (which may be reasonable for reading files with \r\n line delimiter). Default: 100.
-- | - `escapeCodeTimeout` <number> The duration readline will wait for a character (when reading an ambiguous key sequence in milliseconds one that can both form a complete key sequence using the input read so far and can take additional input to complete a longer key sequence). Default: 500.
-- | - `tabSize` <integer> The number of spaces a tab is equal to (minimum 1). Default: 8.
-- | - `signal` <AbortSignal> Allows closing the interface using an AbortSignal. Aborting the signal will internally call close on the interface.
foreign import data InterfaceOptions :: Type

output :: forall w. Option InterfaceOptions (Writable w)
output = opt "output"

completer :: Option InterfaceOptions Completer
completer = opt "completer"

-- | A function which performs tab completion.
-- |
-- | This function takes the partial command as input, and returns a collection of
-- | completions, as well as the matched portion of the input string.
type Completer =
  String
  -> Effect
       { completions :: Array String
       , matched :: String
       }

-- | A completion function which offers no completions.
noCompletion :: Completer
noCompletion s = pure { completions: [], matched: s }

terminal :: Option InterfaceOptions Boolean
terminal = opt "terminal"

history :: Option InterfaceOptions (Array String)
history = opt "historySize"

historySize :: Option InterfaceOptions Int
historySize = opt "historySize"

removeHistoryDuplicates :: Option InterfaceOptions Boolean
removeHistoryDuplicates = opt "removeHistoryDuplicates"

-- | Option for `prompt`; name is changed to prevent naming clash with `prompt` function
promptStr :: Option InterfaceOptions String
promptStr = opt "prompt"

crlfDelay :: Option InterfaceOptions Milliseconds
crlfDelay = opt "crlfDelay"

escapeCodeTimeout :: Option InterfaceOptions Milliseconds
escapeCodeTimeout = opt "escapeCodeTimeout"

tabSize :: Option InterfaceOptions Int
tabSize = opt "tabSize"

signal :: Option InterfaceOptions AbortSignal
signal = opt "signal"

-- | The 'close' event is emitted when one of the following occur:
-- | 
-- | - The `rl.close()` method is called and the readline.Interface instance has relinquished control over the input and output streams;
-- | - The input stream receives its 'end' event;
-- | - The input stream receives `Ctrl+D` to signal end-of-transmission (`EOT`);
-- | - The input stream receives `Ctrl+C` to signal `SIGINT` and there is no `SIGINT` event listener registered on the readline.Interface instance.
-- | 
-- | The listener function is called without passing any arguments.
-- | 
-- | The `readline.Interface` instance is finished once the `close` event is emitted.
closeH :: EventHandle0 Interface
closeH = EventHandle "close" identity

-- | The 'line' event is emitted whenever the input stream receives an end-of-line input (`\n`, `\r`, or `\r\n`). 
-- | This usually occurs when the user presses Enter or Return.
-- | 
-- | The 'line' event is also emitted if new data has been read from a stream and that 
-- | stream ends without a final end-of-line marker.
-- | 
-- | The listener function is called with a string containing the single line of received input.
lineH :: EventHandle1 Interface String
lineH = EventHandle "line" mkEffectFn1

-- | The 'history' event is emitted whenever the history array has changed.
-- | 
-- | The listener function is called with an array containing the history array. It will reflect all changes, added lines and removed lines due to historySize and removeHistoryDuplicates.
-- | 
-- | The primary purpose is to allow a listener to persist the history. It is also possible for the listener to change the history object. This could be useful to prevent certain lines to be added to the history, like a password.
historyH :: EventHandle1 Interface (Array String)
historyH = EventHandle "history" mkEffectFn1

-- | The 'pause' event is emitted when one of the following occur:
-- | 
-- | - The input stream is paused.
-- | - The input stream is not paused and receives the 'SIGCONT' event. (See events 'SIGTSTP' and 'SIGCONT'.)
-- | 
-- | The listener function is called without passing any arguments.
pauseH :: EventHandle0 Interface
pauseH = EventHandle "pause" identity

-- | The 'resume' event is emitted whenever the input stream is resumed.
-- | 
-- | The listener function is called without passing any arguments.
resumeH :: EventHandle0 Interface
resumeH = EventHandle "resume" identity

-- | The 'SIGCONT' event is emitted when a Node.js process previously moved into the background using Ctrl+Z (i.e. SIGTSTP) is then brought back to the foreground using fg(1p).
-- | 
-- | If the input stream was paused before the SIGTSTP request, this event will not be emitted.
-- | 
-- | The listener function is invoked without passing any arguments.
-- |
-- | **The 'SIGCONT' event is not supported on Windows.**
sigContH :: EventHandle0 Interface
sigContH = EventHandle "SIGCONT" identity

-- | The 'SIGINT' event is emitted whenever the input stream receives a Ctrl+C input, known typically as SIGINT. If there are no 'SIGINT' event listeners registered when the input stream receives a SIGINT, the 'pause' event will be emitted.
-- | 
-- | The listener function is invoked without passing any arguments.
sigIntH :: EventHandle0 Interface
sigIntH = EventHandle "SIGINT" identity

-- | The 'SIGTSTP' event is emitted when the input stream receives a Ctrl+Z input, typically known as SIGTSTP. If there are no 'SIGTSTP' event listeners registered when the input stream receives a SIGTSTP, the Node.js process will be sent to the background.
-- | 
-- | When the program is resumed using fg(1p), the 'pause' and 'SIGCONT' events will be emitted. These can be used to resume the input stream.
-- | 
-- | The 'pause' and 'SIGCONT' events will not be emitted if the input was paused before the process was sent to the background.
-- | 
-- | The listener function is invoked without passing any arguments.
-- | 
-- | **The 'SIGTSTP' event is not supported on Windows.**
sigStpH :: EventHandle0 Interface
sigStpH = EventHandle "SIGSTP" identity

-- | Close the specified `Interface`.
-- |
-- | The rl.close() method closes the readline.Interface instance and relinquishes control over the input and output streams. When called, the 'close' event will be emitted.
-- | 
-- | Calling rl.close() does not immediately stop other events (including 'line') from being emitted by the readline.Interface instance.
close :: Interface -> Effect Unit
close iface = runEffectFn1 closeImpl iface

foreign import closeImpl :: EffectFn1 (Interface) (Unit)

-- | The rl.pause() method pauses the input stream, allowing it to be resumed later if necessary.
-- | 
-- | Calling rl.pause() does not immediately pause other events (including 'line') from being emitted by the readline.Interface instance.
pause :: Interface -> Effect Unit
pause iface = runEffectFn1 pauseImpl iface

foreign import pauseImpl :: EffectFn1 (Interface) (Unit)

-- | Prompt the user for input on the specified `Interface`.
prompt :: Interface -> Effect Unit
prompt iface = runEffectFn1 promptImpl iface

foreign import promptImpl :: EffectFn1 (Interface) (Unit)

-- | - `preserveCursor` <boolean> If true, prevents the cursor placement from being reset to 0.
-- | 
-- | The rl.prompt() method writes the readline.Interface instances configured prompt to a new line in output in order to provide a user with a new location at which to provide input.
-- | 
-- | When called, rl.prompt() will resume the input stream if it has been paused.
-- | 
-- | If the readline.Interface was created with output set to null or undefined the prompt is not written.
prompt' :: Boolean -> Interface -> Effect Unit
prompt' preserveCursor iface = runEffectFn2 promptOptsImpl preserveCursor iface

foreign import promptOptsImpl :: EffectFn2 (Boolean) (Interface) (Unit)

-- | Writes a query to the output, waits
-- | for user input to be provided on input, then invokes
-- | the callback function
-- |
-- | Args:
-- |   - `query` <string> A statement or query to write to output, prepended to the prompt.
-- |   - `options` <Object>
-- |        - `signal` <AbortSignal> Optionally allows the question() to be canceled using an AbortController.
-- |   - `callback` <Function> A callback function that is invoked with the user's input in response to the query.
-- | 
-- | The `rl.question()` method displays the query by writing it to the output, waits for user input to be provided on input, then invokes the callback function passing the provided input as the first argument.
-- | 
-- | When called, `rl.question()` will resume the input stream if it has been paused.
-- | 
-- | If the readline.Interface was created with output set to null or undefined the query is not written.
-- | 
-- | The callback function passed to `rl.question()` does not follow the typical pattern of accepting an Error object or null as the first argument. The callback is called with the provided answer as the only argument.
question :: String -> (String -> Effect Unit) -> Interface -> Effect Unit
question text cb iface = runEffectFn3 questionImpl iface text $ mkEffectFn1 cb

foreign import questionImpl :: EffectFn3 (Interface) (String) (EffectFn1 String Unit) Unit

-- | Writes a query to the output, waits
-- | for user input to be provided on input, then invokes
-- | the callback function
-- |
-- | Args:
-- |   - `query` <string> A statement or query to write to output, prepended to the prompt.
-- |   - `options` <Object>
-- |        - `signal` <AbortSignal> Optionally allows the question() to be canceled using an AbortController.
-- |   - `callback` <Function> A callback function that is invoked with the user's input in response to the query.
-- | 
-- | The `rl.question()` method displays the query by writing it to the output, waits for user input to be provided on input, then invokes the callback function passing the provided input as the first argument.
-- | 
-- | When called, `rl.question()` will resume the input stream if it has been paused.
-- | 
-- | If the readline.Interface was created with output set to null or undefined the query is not written.
-- | 
-- | The callback function passed to `rl.question()` does not follow the typical pattern of accepting an Error object or null as the first argument. The callback is called with the provided answer as the only argument.
question' :: String -> { signal :: AbortSignal } -> (String -> Effect Unit) -> Interface -> Effect Unit
question' text opts cb iface = runEffectFn4 questionOptsCbImpl iface text opts $ mkEffectFn1 cb

foreign import questionOptsCbImpl :: EffectFn4 (Interface) (String) { signal :: AbortSignal } (EffectFn1 String Unit) Unit

-- | The rl.resume() method resumes the input stream if it has been paused.
resume :: Interface -> Effect Unit
resume iface = runEffectFn1 resumeImpl iface

foreign import resumeImpl :: EffectFn1 (Interface) (Unit)

-- | The rl.setPrompt() method sets the prompt that will be written to output whenever rl.prompt() is called.
setPrompt :: String -> Interface -> Effect Unit
setPrompt newPrompt iface = runEffectFn2 setPromptImpl iface newPrompt

foreign import setPromptImpl :: EffectFn2 (Interface) (String) (Unit)

getPrompt :: Interface -> Effect String
getPrompt iface = runEffectFn1 getPromptImpl iface

foreign import getPromptImpl :: EffectFn1 (Interface) (String)

writeData :: String -> Interface -> Effect Unit
writeData dataStr iface = runEffectFn2 writeDataImpl dataStr iface

foreign import writeDataImpl :: EffectFn2 (String) (Interface) (Unit)

-- | - `name` <string> The name of the a key.
-- | - `ctrl` <boolean> true to indicate the Ctrl key.
-- | - `meta` <boolean> true to indicate the Meta key.
-- | - `shift` <boolean> true to indicate the Shift key.
type KeySequenceObj =
  { name :: String
  , ctrl :: Boolean
  , meta :: Boolean
  , shift :: Boolean
  }

writeKey :: KeySequenceObj -> Interface -> Effect Unit
writeKey keySeq iface = runEffectFn2 writeKeyImpl keySeq iface

foreign import writeKeyImpl :: EffectFn2 (KeySequenceObj) (Interface) (Unit)

line :: Interface -> Effect String
line iface = runEffectFn1 lineImpl iface

foreign import lineImpl :: EffectFn1 (Interface) (String)

cursor :: Interface -> Effect Int
cursor iface = runEffectFn1 cursorImpl iface

foreign import cursorImpl :: EffectFn1 (Interface) (Int)

type CursorPos =
  { rows :: Int
  , cols :: Int
  }

getCursorPos :: Interface -> Effect CursorPos
getCursorPos iface = runEffectFn1 getCursorPosImpl iface

foreign import getCursorPosImpl :: EffectFn1 (Interface) (CursorPos)

clearLineLeft :: forall r. Writable r -> Effect Boolean
clearLineLeft stream = runEffectFn1 clearLineLeftImpl stream

foreign import clearLineLeftImpl :: forall r. EffectFn1 (Writable r) (Boolean)

clearLineLeft' :: forall r. Writable r -> Effect Unit -> Effect Boolean
clearLineLeft' stream cb = runEffectFn2 clearLineLeftCbImpl stream cb

foreign import clearLineLeftCbImpl :: forall r. EffectFn2 (Writable r) (Effect Unit) (Boolean)

clearLineRight :: forall r. Writable r -> Effect Boolean
clearLineRight stream = runEffectFn1 clearLineRightImpl stream

foreign import clearLineRightImpl :: forall r. EffectFn1 (Writable r) (Boolean)

clearLineRight' :: forall r. Writable r -> Effect Unit -> Effect Boolean
clearLineRight' stream cb = runEffectFn2 clearLineRightCbImpl stream cb

foreign import clearLineRightCbImpl :: forall r. EffectFn2 (Writable r) (Effect Unit) (Boolean)

clearEntireLine :: forall r. Writable r -> Effect Boolean
clearEntireLine stream = runEffectFn1 clearEntireLineImpl stream

foreign import clearEntireLineImpl :: forall r. EffectFn1 (Writable r) (Boolean)

clearEntireLine' :: forall r. Writable r -> Effect Unit -> Effect Boolean
clearEntireLine' stream cb = runEffectFn2 clearEntireLineCbImpl stream cb

foreign import clearEntireLineCbImpl :: forall r. EffectFn2 (Writable r) (Effect Unit) (Boolean)

clearScreenDown :: forall r. Writable r -> Effect Boolean
clearScreenDown stream = runEffectFn1 clearScreenDownImpl stream

foreign import clearScreenDownImpl :: forall r. EffectFn1 (Writable r) (Boolean)

clearScreenDown' :: forall r. Writable r -> Effect Unit -> Effect Boolean
clearScreenDown' stream cb = runEffectFn2 clearScreenDownCbImpl stream cb

foreign import clearScreenDownCbImpl :: forall r. EffectFn2 (Writable r) (Effect Unit) (Boolean)

cursorToX :: forall r. Writable r -> Int -> Effect Boolean
cursorToX stream x = runEffectFn2 cursorToXImpl stream x

foreign import cursorToXImpl :: forall r. EffectFn2 (Writable r) (Int) (Boolean)

cursorToX' :: forall r. Writable r -> Int -> Effect Unit -> Effect Boolean
cursorToX' stream x cb = runEffectFn3 cursorToXCbImpl stream x cb

foreign import cursorToXCbImpl :: forall r. EffectFn3 (Writable r) (Int) (Effect Unit) (Boolean)

cursorToXY :: forall r. Writable r -> Int -> Int -> Effect Boolean
cursorToXY stream x y = runEffectFn3 cursorToXYImpl stream x y

foreign import cursorToXYImpl :: forall r. EffectFn3 (Writable r) (Int) (Int) (Boolean)

cursorToXY' :: forall r. Writable r -> Int -> Int -> Effect Unit -> Effect Boolean
cursorToXY' stream x y cb = runEffectFn4 cursorToXYCbImpl stream x y cb

foreign import cursorToXYCbImpl :: forall r. EffectFn4 (Writable r) (Int) (Int) (Effect Unit) (Boolean)

emitKeyPressEvents :: forall w. Readable w -> Effect Unit
emitKeyPressEvents stream = runEffectFn1 emitKeyPressEventsImpl stream

foreign import emitKeyPressEventsImpl :: forall w. EffectFn1 (Readable w) (Unit)

emitKeyPressEvents' :: forall w. Readable w -> Interface -> Effect Unit
emitKeyPressEvents' stream iface = runEffectFn2 emitKeyPressEventsIfaceImpl stream iface

foreign import emitKeyPressEventsIfaceImpl :: forall w. EffectFn2 (Readable w) (Interface) (Unit)

moveCursorXY :: forall r. Writable r -> Int -> Int -> Effect Boolean
moveCursorXY stream x y = runEffectFn3 moveCursorXYImpl stream x y

foreign import moveCursorXYImpl :: forall r. EffectFn3 (Writable r) (Int) (Int) (Boolean)

moveCursorXY' :: forall r. Writable r -> Int -> Int -> Effect Unit -> Effect Boolean
moveCursorXY' stream x y cb = runEffectFn4 moveCursorXYCbImpl stream x y cb

foreign import moveCursorXYCbImpl :: forall r. EffectFn4 (Writable r) (Int) (Int) (Effect Unit) (Boolean)
