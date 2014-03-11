module Main where

import Prelude
import Control.Monad
import Control.Monad.Eff
import System.ReadLine
import Debug.Trace
import Data.Tuple

completion :: forall eff. Completer eff
completion s = return $ Tuple [] s

lineHandler s = trace $ "You typed: " ++ s

main = do
  interface <- createInterface process.stdin process.stdout completion
  setPrompt "? " 2 interface
  prompt interface
  setLineHandler lineHandler interface
