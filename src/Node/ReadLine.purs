-- | This module provides a binding to the Node `readline` API.

module Node.ReadLine where

import Prelude (return)

import Control.Monad.Eff
import Control.Monad.Eff.Console

-- | A handle to a console interface.
-- |
-- | A handle can be created with the `createInterface` function.
foreign import data Interface :: *

-- | A function which performs tab completion.
-- |
-- | This function takes the partial command as input, and returns a collection of 
-- | completions, as well as the matched portion of the input string.
type Completer eff = String -> Eff (console :: CONSOLE | eff) { completions :: Array String, matched :: String }

-- | A function which handles input from the user.
type LineHandler eff a = String -> Eff (console :: CONSOLE | eff) a 

-- | Set the current line handler function.
foreign import setLineHandler :: forall eff a. LineHandler eff a -> Interface -> Eff (console :: CONSOLE | eff) Interface

-- | Prompt the user for input on the specified `Interface`.
foreign import prompt :: forall eff. Interface -> Eff (console :: CONSOLE | eff) Interface

-- | Set the prompt.
foreign import setPrompt :: forall eff. String -> Int -> Interface -> Eff (console :: CONSOLE | eff) Interface

-- | Create an interface with the specified completion function.
foreign import createInterface :: forall eff. Completer eff -> Eff (console :: CONSOLE | eff) Interface

-- | Close the specified `Interface`.
foreign import close :: forall eff. Interface -> Eff (console :: CONSOLE | eff) Interface

-- | A completion function which offers no completions.
noCompletion :: forall eff. Completer eff
noCompletion s = return { completions: [], matched: s }

