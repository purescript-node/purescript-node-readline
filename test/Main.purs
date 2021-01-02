module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Node.ReadLine (prompt, close, setLineHandler, setPrompt,  noCompletion, createConsoleInterface)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  setPrompt "> " interface
  prompt interface
  setLineHandler interface $ \s ->
    if s == "quit"
       then close interface
       else do
        log $ "You typed: " <> s
        prompt interface
