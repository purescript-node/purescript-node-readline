module Main where

import Control.Monad.Eff
import Node.ReadLine
import Debug.Trace

main = do
  interface <- createInterface process.stdin process.stdout noCompletion
  
  let
    lineHandler s = do
      trace $ "You typed: " ++ s
      prompt interface
  
  setPrompt "? " 2 interface
  prompt interface
  setLineHandler lineHandler interface
