module Test.Main where

import Prelude

import Control.Monad.Eff
import Control.Monad.Eff.Console

import Node.ReadLine

main = do
  interface <- createInterface noCompletion
  
  let
    lineHandler s = do
      log $ "You typed: " ++ s
      prompt interface
  
  setPrompt "> " 2 interface
  prompt interface
  setLineHandler lineHandler interface
