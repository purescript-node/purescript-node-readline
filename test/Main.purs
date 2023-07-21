module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Node.EventEmitter (on_)
import Node.ReadLine (close, createConsoleInterface, lineH, noCompletion, prompt, setPrompt)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  setPrompt "(type 'quit' to stop)\n> " interface
  prompt interface
  interface # on_ lineH \s ->
    if s == "quit" then close interface
    else do
      log $ "You typed: " <> s
      prompt interface
