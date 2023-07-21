module Node.Errors.AbortSignal
  ( AbortSignal
  , toEventEmitter
  , newAbort
  , newAbort'
  , newTimeout
  , abortH
  , aborted
  , reason
  , throwIfAborted
  ) where

import Prelude

import Data.Time.Duration (Milliseconds)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Foreign (Foreign)
import Node.EventEmitter (EventEmitter, EventHandle(..))
import Node.EventEmitter.UtilTypes (EventHandle0)
import Unsafe.Coerce (unsafeCoerce)

foreign import data AbortSignal :: Type

toEventEmitter :: AbortSignal -> EventEmitter
toEventEmitter = unsafeCoerce

foreign import newAbort :: Effect (AbortSignal)

newAbort' :: forall a. a -> Effect AbortSignal
newAbort' reason' = runEffectFn1 newAbortReasonImpl reason'

foreign import newAbortReasonImpl :: forall a. EffectFn1 (a) (AbortSignal)

newTimeout :: Milliseconds -> Effect AbortSignal
newTimeout delay = runEffectFn1 timeoutImpl delay

foreign import timeoutImpl :: EffectFn1 (Milliseconds) (AbortSignal)

-- | The 'abort' event is emitted when the abortController.abort() method is called. The callback is invoked with a single object argument with a single type property set to 'abort':
-- | 
-- | We recommended that code check that the `abortSignal.aborted` attribute is false before adding an 'abort' event listener.
-- |
-- | Any event listeners attached to the AbortSignal should use the { once: true } option (or, if using the EventEmitter APIs to attach a listener, use the once() method) to ensure that the event listener is removed as soon as the 'abort' event is handled. Failure to do so may result in memory leaks.
abortH :: EventHandle0 AbortSignal
abortH = EventHandle "abort" identity

aborted :: AbortSignal -> Effect Boolean
aborted sig = runEffectFn1 abortedImpl sig

foreign import abortedImpl :: EffectFn1 (AbortSignal) (Boolean)

reason :: AbortSignal -> Effect Foreign
reason sig = runEffectFn1 reasonImpl sig

foreign import reasonImpl :: EffectFn1 (AbortSignal) (Foreign)

throwIfAborted :: AbortSignal -> Effect Unit
throwIfAborted sig = runEffectFn1 throwIfAbortedImpl sig

foreign import throwIfAbortedImpl :: EffectFn1 (AbortSignal) (Unit)
