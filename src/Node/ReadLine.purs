module Node.ReadLine where

import Control.Monad.Eff

foreign import data Console :: !

foreign import data Interface :: *

foreign import data InputStream :: *

foreign import data OutputStream :: *

foreign import process :: { stderr :: OutputStream, stdout :: OutputStream, stdin :: InputStream }

type Completer eff = String -> Eff eff { completions :: [String], matched :: String }

type LineHandler eff a = String -> Eff (console :: Console | eff) a 

foreign import setLineHandler 
  "function setLineHandler(callback) {\
  \  return function(readline) {\
  \    return function() {\
  \      readline.removeAllListeners('line');\
  \      readline.on('line', function (line) {\
  \        callback(line)();\
  \      });\
  \      return readline;\
  \    };\
  \  };\
  \};" :: forall eff a. LineHandler eff a -> Interface -> Eff (console :: Console | eff) Interface

foreign import prompt 
  "function prompt(readline) {\
  \  return function() {\
  \    readline.prompt();\
  \    return readline;\
  \  };\
  \};" :: forall eff. Interface -> Eff (console :: Console | eff) Interface

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
  \}" :: forall eff. Prim.String -> Prim.Number -> Interface -> Eff (console :: Console | eff) Interface

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
  \            var res = completer(line)();\
  \            return [res.completions, res.suffix];\
  \          }\
  \        });\
  \      };\
  \    };\
  \  };\
  \}" :: forall eff. InputStream -> OutputStream -> Completer eff -> Eff (console :: Console | eff) Interface

noCompletion :: forall eff. Completer eff
noCompletion s = return { completions: [], matched: s }

