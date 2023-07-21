module Node.Errors.AbortController
  ( AbortController
  , new
  , abort
  , abort'
  , signal
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1, runEffectFn2)
import Node.Errors.AbortSignal (AbortSignal)
import Node.EventEmitter (EventHandle(..))
import Node.EventEmitter.UtilTypes (EventHandle0)

foreign import data AbortController :: Type

foreign import new :: Effect (AbortController)

abort :: AbortController -> Effect Unit
abort c = runEffectFn1 abortImpl c

foreign import abortImpl :: EffectFn1 (AbortController) (Unit)

abort' :: forall a. AbortController -> a -> Effect Unit
abort' c reason = runEffectFn2 abortReasonImpl c reason

foreign import abortReasonImpl :: forall a. EffectFn2 (AbortController) (a) (Unit)

foreign import signal :: AbortController -> AbortSignal
