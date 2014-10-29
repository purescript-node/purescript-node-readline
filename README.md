# Module Documentation

## Module Node.ReadLine

### Types

    type Completer eff = String -> Eff eff { matched :: String, completions :: [String] }

    data Console :: !

    data InputStream :: *

    data Interface :: *

    type LineHandler eff a = String -> Eff (console :: Console | eff) a

    data OutputStream :: *


### Values

    createInterface :: forall eff. InputStream -> OutputStream -> Completer eff -> Eff (console :: Console | eff) Interface

    noCompletion :: forall eff. Completer eff

    process :: { stdin :: InputStream, stdout :: OutputStream, stderr :: OutputStream }

    prompt :: forall eff. Interface -> Eff (console :: Console | eff) Interface

    setLineHandler :: forall eff a. LineHandler eff a -> Interface -> Eff (console :: Console | eff) Interface

    setPrompt :: forall eff. String -> Number -> Interface -> Eff (console :: Console | eff) Interface