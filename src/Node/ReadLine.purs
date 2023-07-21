-- | This module provides a binding to the Node `readline` API.

module Node.ReadLine
  ( Interface
  , InterfaceOptions
  , Completer
  , LineHandler
  , createInterface
  , createConsoleInterface
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
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, runEffectFn1, runEffectFn2, runEffectFn3)
import Foreign (Foreign)
import Node.Process (stdin, stdout)
import Node.Stream (Readable, Writable)

-- | A handle to a console interface.
-- |
-- | A handle can be created with the `createInterface` function.
foreign import data Interface :: Type

foreign import createInterfaceImpl :: Foreign -> Effect Interface

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
