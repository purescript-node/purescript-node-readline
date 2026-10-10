module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Effect.Exception (throw)
import Effect.Ref as Ref
import Node.EventEmitter (on_)
import Node.ReadLine (close, closeH, createConsoleInterface, getPrompt, lineH, noCompletion, question, setPrompt, writeData)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  setPrompt "readline-test> " interface
  actualPrompt <- getPrompt interface
  unless (actualPrompt == "readline-test> ") $ throw "Prompt did not round-trip"

  lines <- Ref.new ""
  interface # on_ lineH \s -> Ref.modify_ (_ <> s <> "|") lines
  writeData "first\nsecond\n" interface
  actualLines <- Ref.read lines
  unless (actualLines == "first|second|") $ throw "Line events did not match input"

  answer <- Ref.new ""
  question "Question? " (\s -> Ref.write s answer) interface
  writeData "reply\n" interface
  actualAnswer <- Ref.read answer
  unless (actualAnswer == "reply") $ throw "Question callback did not receive the answer"

  closed <- Ref.new false
  interface # on_ closeH (Ref.write true closed)
  close interface
  didClose <- Ref.read closed
  unless didClose $ throw "Close event was not emitted"
  log "Readline tests passed"
