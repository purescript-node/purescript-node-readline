module Test.Main where

import Prelude
import Control.Monad.Eff.Console
import Node.ReadLine

main = do
  interface <- createConsoleInterface noCompletion
  
  setPrompt "> " 2 interface
  prompt interface
  setLineHandler interface $ \s ->
    if s == "quit"
       then close interface
       else do
        log $ "You typed: " ++ s
        prompt interface
