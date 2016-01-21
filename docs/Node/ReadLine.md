## Module Node.ReadLine

This module provides a binding to the Node `readline` API.

#### `Interface`

``` purescript
data Interface :: *
```

A handle to a console interface.

A handle can be created with the `createInterface` function.

#### `READLINE`

``` purescript
data READLINE :: !
```

The effect of interacting with a stream via an `Interface`

#### `InterfaceOptions`

``` purescript
data InterfaceOptions
```

Options passed to `readline`'s `createInterface`

#### `output`

``` purescript
output :: forall w eff. Option InterfaceOptions (Writable w eff)
```

#### `completer`

``` purescript
completer :: forall eff. Option InterfaceOptions (Completer eff)
```

#### `terminal`

``` purescript
terminal :: Option InterfaceOptions Boolean
```

#### `historySize`

``` purescript
historySize :: Option InterfaceOptions Int
```

#### `Completer`

``` purescript
type Completer eff = String -> Eff eff { completions :: Array String, matched :: String }
```

A function which performs tab completion.

This function takes the partial command as input, and returns a collection of
completions, as well as the matched portion of the input string.

#### `createInterface`

``` purescript
createInterface :: forall r eff. Readable r eff -> Options InterfaceOptions -> Eff (readline :: READLINE | eff) Interface
```

Builds an interface with the specified options.

#### `createConsoleInterface`

``` purescript
createConsoleInterface :: forall eff. Completer (readline :: READLINE, console :: CONSOLE, err :: EXCEPTION | eff) -> Eff (readline :: READLINE, console :: CONSOLE, err :: EXCEPTION | eff) Interface
```

Create an interface with the specified completion function.

#### `noCompletion`

``` purescript
noCompletion :: forall eff. Completer eff
```

A completion function which offers no completions.

#### `prompt`

``` purescript
prompt :: forall eff. Interface -> Eff (readline :: READLINE | eff) Interface
```

Prompt the user for input on the specified `Interface`.

#### `setPrompt`

``` purescript
setPrompt :: forall eff. String -> Int -> Interface -> Eff (readline :: READLINE | eff) Interface
```

Set the prompt.

#### `close`

``` purescript
close :: forall eff. Interface -> Eff (readline :: READLINE | eff) Interface
```

Close the specified `Interface`.

#### `LineHandler`

``` purescript
type LineHandler eff a = String -> Eff eff a
```

A function which handles each line of input.

#### `setLineHandler`

``` purescript
setLineHandler :: forall eff a. Interface -> LineHandler (readline :: READLINE | eff) a -> Eff (readline :: READLINE | eff) Interface
```

Set the current line handler function.


