module Node.ReadLine.Aff
  ( question
  , question'
  , blockUntilClosed
  , countLines
  ) where

import Prelude

import Data.Either (Either(..))
import Effect.Aff (Aff, effectCanceler, error, makeAff, nonCanceler)
import Effect.Class (liftEffect)
import Effect.Exception (Error, throw)
import Effect.Ref as Ref
import Effect.Uncurried (mkEffectFn1)
import Node.Errors.AbortController (AbortController, abort', signal)
import Node.Errors.AbortSignal (abortH, aborted)
import Node.EventEmitter (EventHandle(..), on, once)
import Node.EventEmitter.UtilTypes (EventHandle1)
import Node.ReadLine (Interface, closeH, lineH)
import Node.ReadLine as RL

-- | Blocks until receives user input. There is no way to cancel this.
question :: String -> Interface -> Aff String
question txt iface = makeAff \done -> do
  RL.question txt (done <<< Right) iface
  pure nonCanceler

-- | Blocks until receives user input. An `AbortController` can be used to cancel this.
-- | If the `AbortSignal` is aborted outside of this function, this computation
-- | will produce an error. If the `AbortSignal` is already aborted, this will throw an error.
question' :: String -> AbortController -> Interface -> Aff String
question' txt controller iface = do
  let sig = signal controller
  -- Node docs:
  -- > We recommended that code check that the `abortSignal.aborted` 
  -- > attribute is `false` before adding an 'abort' event listener.
  liftEffect do
    alreadyAborted <- aborted sig
    when alreadyAborted do
      throw "Signal was already aborted before calling 'question'"
  makeAff \done -> do
    rmAbortListener <- sig # once abortH do
      done $ Left $ error "Signal was aborted after calling 'question'"
    RL.question' txt { signal: sig } (done <<< Right) iface
    pure $ effectCanceler do
      rmAbortListener
      abort' controller "Cancelled"

blockUntilClosed :: Interface -> Aff Unit
blockUntilClosed iface = makeAff \done -> do
  rmListener <- iface # once closeH (done $ Right unit)
  pure $ effectCanceler rmListener

-- Note: I'm not sure if this is needed, but it's not clear
-- from the Node docs that a `close` event will occur
-- if there's an error in either the `input` or `output` streams.
-- Moreover, `EventEmitter` docs say it's best practices to listen
-- for `error` events.
-- > As a best practice, listeners should always be added for the 'error' events.
errorH :: EventHandle1 Interface Error
errorH = EventHandle "error" mkEffectFn1

countLines :: Interface -> Aff Int
countLines iface = makeAff \done -> do
  countRef <- Ref.new 0
  rmErrListener <- iface # once errorH (done <<< Left)
  rmCloseListener <- iface # once closeH do
    rmErrListener
    done <<< Right =<< Ref.read countRef
  rmLineListener <- iface # on lineH \_ -> Ref.modify_ (_ + 1) countRef
  pure $ effectCanceler do
    rmErrListener
    rmCloseListener
    rmLineListener
