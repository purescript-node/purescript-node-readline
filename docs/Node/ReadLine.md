## Module Node.ReadLine

This module provides a binding to the Node `readline` API.

#### `Interface`

``` purescript
data Interface :: *
```

A handle to a console interface.

A handle can be created with the `createInterface` function.

#### `Completer`

``` purescript
type Completer eff = String -> Eff (console :: CONSOLE | eff) { completions :: Array String, matched :: String }
```

A function which performs tab completion.

This function takes the partial command as input, and returns a collection of 
completions, as well as the matched portion of the input string.

#### `LineHandler`

``` purescript
type LineHandler eff a = String -> Eff (console :: CONSOLE | eff) a
```

A function which handles input from the user.

#### `setLineHandler`

``` purescript
setLineHandler :: forall eff a. Interface -> LineHandler eff a -> Eff (console :: CONSOLE | eff) Interface
```

Set the current line handler function.

#### `prompt`

``` purescript
prompt :: forall eff. Interface -> Eff (console :: CONSOLE | eff) Interface
```

Prompt the user for input on the specified `Interface`.

#### `setPrompt`

``` purescript
setPrompt :: forall eff. String -> Int -> Interface -> Eff (console :: CONSOLE | eff) Interface
```

Set the prompt.

#### `createInterface`

``` purescript
createInterface :: forall eff. Completer eff -> Eff (console :: CONSOLE | eff) Interface
```

Create an interface with the specified completion function.

#### `close`

``` purescript
close :: forall eff. Interface -> Eff (console :: CONSOLE | eff) Interface
```

Close the specified `Interface`.

#### `noCompletion`

``` purescript
noCompletion :: forall eff. Completer eff
```

A completion function which offers no completions.


