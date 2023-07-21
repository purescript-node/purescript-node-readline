-- | This module provides a binding to the Node `readline` API.

module Node.ReadLine
  ( Interface
  , toEventEmitter
  , InterfaceOptions
  , Completer
  , LineHandler
  , createInterface
  , createConsoleInterface
  , closeH
  , lineH
  , historyH
  , pauseH
  , resumeH
  , sigContH
  , sigIntH
  , sigStpH
  , output
  , completer
  , terminal
  , historySize
  , noCompletion
  , prompt
  , setPrompt
  , setLineHandler
  , close
  , question
  ) where

import Prelude

import Data.Options (Options, Option, (:=), options, opt)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, mkEffectFn1, runEffectFn1, runEffectFn2, runEffectFn3)
import Foreign (Foreign)
import Node.EventEmitter (EventEmitter, EventHandle(..))
import Node.EventEmitter.UtilTypes (EventHandle0, EventHandle1)
import Node.Process (stdin, stdout)
import Node.Stream (Readable, Writable)
import Unsafe.Coerce (unsafeCoerce)

-- | A handle to a console interface.
-- |
-- | A handle can be created with the `createInterface` function.
foreign import data Interface :: Type

toEventEmitter :: Interface -> EventEmitter
toEventEmitter = unsafeCoerce

foreign import createInterfaceImpl :: Foreign -> Effect Interface

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

-- | Options passed to `readline`'s `createInterface`
foreign import data InterfaceOptions :: Type

output :: forall w. Option InterfaceOptions (Writable w)
output = opt "output"

completer :: Option InterfaceOptions Completer
completer = opt "completer"

terminal :: Option InterfaceOptions Boolean
terminal = opt "terminal"

historySize :: Option InterfaceOptions Int
historySize = opt "historySize"

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

-- | Builds an interface with the specified options.
createInterface
  :: forall r
   . Readable r
  -> Options InterfaceOptions
  -> Effect Interface
createInterface input opts = createInterfaceImpl
  $ options
  $ opts
      <> opt "input" := input

-- | Create an interface with the specified completion function.
createConsoleInterface :: Completer -> Effect Interface
createConsoleInterface compl =
  createInterface stdin
    $ output := stdout
        <> completer := compl

-- | A completion function which offers no completions.
noCompletion :: Completer
noCompletion s = pure { completions: [], matched: s }

-- | Prompt the user for input on the specified `Interface`.
prompt :: Interface -> Effect Unit
prompt iface = runEffectFn1 promptImpl iface

foreign import promptImpl :: EffectFn1 (Interface) (Unit)

-- | Writes a query to the output, waits
-- | for user input to be provided on input, then invokes
-- | the callback function
question :: String -> (String -> Effect Unit) -> Interface -> Effect Unit
question text cb iface = runEffectFn3 questionImpl iface text cb

foreign import questionImpl :: EffectFn3 (Interface) (String) ((String -> Effect Unit)) Unit

-- | Set the prompt.
setPrompt :: String -> Interface -> Effect Unit
setPrompt newPrompt iface = runEffectFn2 setPromptImpl iface newPrompt

foreign import setPromptImpl :: EffectFn2 (Interface) (String) (Unit)

-- | Close the specified `Interface`.
close :: Interface -> Effect Unit
close iface = runEffectFn1 closeImpl iface

foreign import closeImpl :: EffectFn1 (Interface) (Unit)

-- | A function which handles each line of input.
type LineHandler a = String -> Effect a

-- | Set the current line handler function.
setLineHandler :: forall a. LineHandler a -> Interface -> Effect Unit
setLineHandler cb iface = runEffectFn2 setLineHandlerImpl iface cb

foreign import setLineHandlerImpl :: forall a. EffectFn2 (Interface) (LineHandler a) (Unit)
