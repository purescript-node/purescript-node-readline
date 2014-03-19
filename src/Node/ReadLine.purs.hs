module System.ReadLine where

import Data.Tuple
import Control.Monad.Eff

foreign import data Console :: !

foreign import data Interface :: *

foreign import data InputStream :: *

foreign import data OutputStream :: *

foreign import process :: { stderr :: OutputStream, stdout :: OutputStream, stdin :: System.ReadLine.InputStream }

type Completer eff = String -> Eff eff (Tuple [String] String)

type LineHandler eff = String -> Eff eff {}

foreign import setLineHandler 
  "function setLineHandler(callback) {\
  \  return function(readline) {\
  \    return function() {\
  \      readline.on('line', function (line) {\
  \        callback(line)();\
  \      });\
  \      return readline;\
  \    };\
  \  };\
  \};" :: forall eff. LineHandler eff -> Interface -> Control.Monad.Eff.Eff (console :: System.ReadLine.Console | eff) System.ReadLine.Interface

foreign import prompt 
  "function prompt(readline) {\
  \  return function() {\
  \    readline.prompt();\
  \    return readline;\
  \  };\
  \};" :: forall eff. Interface -> Control.Monad.Eff.Eff (console :: Console | eff) System.ReadLine.Interface

foreign import setPrompt 
  "function setPrompt(prompt) {\
  \  return function(length) {\
  \    return function(readline) {\
  \      return function() {\
  \        readline.setPrompt(prompt, length);\
  \        return readline;\
  \      };\
  \    };\
  \  };\
  \}" :: forall eff. Prim.String -> Prim.Number -> Interface -> Control.Monad.Eff.Eff (console :: Console | eff) System.ReadLine.Interface

foreign import createInterface 
  "function createInterface(input) {\
  \  return function(output) {\
  \    return function(completer) {\
  \      return function() {\
  \        var readline = require('readline');\
  \        return readline.createInterface({\
  \          input: input,\
  \          output: output,\
  \          completer: function(line) {\
  \            var completions = completer(line)();\
  \            return completions.values;\
  \          }\
  \        });\
  \      };\
  \    };\
  \  };\
  \}" :: forall eff. InputStream -> OutputStream -> System.ReadLine.Completer eff -> Control.Monad.Eff.Eff (console :: System.ReadLine.Console | eff) System.ReadLine.Interface


