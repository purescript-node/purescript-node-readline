-- | This module provides a binding to the Node `readline` API.

module Node.ReadLine
  ( Interface
  , READLINE
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
  ) where

import Prelude (Unit, return, (<>), ($))
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Foreign (Foreign)
import Data.Options (Options, Option, (:=), options, opt)
import Node.Process (stdin, stdout)
import Node.Stream (Readable, Writable)

-- | A handle to a console interface.
-- |
-- | A handle can be created with the `createInterface` function.
foreign import data Interface :: *

-- | The effect of interacting with a stream via an `Interface`
foreign import data READLINE :: !

foreign import createInterfaceImpl :: forall eff.
                                      Foreign
                                   -> Eff ( readline :: READLINE
                                          | eff
                                          ) Interface

-- | Options passed to `readline`'s `createInterface`
data InterfaceOptions

output :: forall w eff. Option InterfaceOptions (Writable w eff)
output = opt "output"

completer :: forall eff. Option InterfaceOptions (Completer eff)
completer = opt "completer"

terminal :: Option InterfaceOptions Boolean
terminal = opt "terminal"

historySize :: Option InterfaceOptions Int
historySize = opt "historySize"

-- | A function which performs tab completion.
-- |
-- | This function takes the partial command as input, and returns a collection of
-- | completions, as well as the matched portion of the input string.
type Completer eff = String -> Eff eff { completions :: Array String
                                       , matched :: String }

-- | Builds an interface with the specified options.
createInterface :: forall r eff.
                   Readable r ( readline :: READLINE
                              | eff
                              )
                -> Options InterfaceOptions
                -> Eff ( readline :: READLINE
                       | eff
                       ) Interface
createInterface input opts = createInterfaceImpl
  $ options $ opts
           <> opt "input" := input

-- | Create an interface with the specified completion function.
createConsoleInterface :: forall eff.
                          Completer ( readline :: READLINE
                                    , console :: CONSOLE
                                    , err :: EXCEPTION
                                    | eff
                                    )
                       -> Eff ( readline :: READLINE
                              , console :: CONSOLE
                              , err :: EXCEPTION
                              | eff
                              ) Interface
createConsoleInterface compl = createInterface stdin $ output := stdout
                                                    <> completer := compl

-- | A completion function which offers no completions.
noCompletion :: forall eff. Completer eff
noCompletion s = return { completions: [], matched: s }

-- | Prompt the user for input on the specified `Interface`.
foreign import prompt :: forall eff.
                         Interface
                      -> Eff ( readline :: READLINE
                             | eff
                             ) Unit

-- | Set the prompt.
foreign import setPrompt :: forall eff.
                            String
                         -> Int
                         -> Interface
                         -> Eff ( readline :: READLINE
                                | eff
                                ) Unit

-- | Close the specified `Interface`.
foreign import close :: forall eff.
                        Interface
                     -> Eff ( readline :: READLINE
                            | eff
                            ) Unit

-- | A function which handles each line of input.
type LineHandler eff a = String -> Eff eff a

-- | Set the current line handler function.
foreign import setLineHandler :: forall eff a.
                                 Interface
                              -> LineHandler ( readline :: READLINE
                                             | eff
                                             ) a
                              -> Eff ( readline :: READLINE
                                     | eff
                                     ) Unit
