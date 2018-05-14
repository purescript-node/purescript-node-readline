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

import Effect (Effect)

import Foreign (Foreign)
import Data.Options (Options, Option, (:=), options, opt)

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
type Completer
  = String
  -> Effect
      { completions :: Array String
      , matched :: String
      }

-- | Builds an interface with the specified options.
createInterface
  :: forall r
   .  Readable r
  -> Options InterfaceOptions
  -> Effect Interface
createInterface input opts = createInterfaceImpl
  $ options $ opts
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
foreign import prompt :: Interface -> Effect Unit

-- | Writes a query to the output, waits
-- | for user input to be provided on input, then invokes
-- | the callback function
foreign import question
  :: String
  -> (String -> Effect Unit)
  -> Interface
  -> Effect Unit

-- | Set the prompt.
foreign import setPrompt
  :: String
  -> Int
  -> Interface
  -> Effect Unit

-- | Close the specified `Interface`.
foreign import close :: Interface -> Effect Unit

-- | A function which handles each line of input.
type LineHandler a = String -> Effect a

-- | Set the current line handler function.
foreign import setLineHandler
  :: forall a
   . Interface
  -> LineHandler a
  -> Effect Unit
