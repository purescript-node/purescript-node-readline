export const newAbort = () => AbortSignal.abort();
export const newAbortReasonImpl = (reason) => AbortSignal.abort(reason);
export const timeoutImpl = (delay) => AbortSignal.timeout(delay);
export const abortedImpl = (sig) => sig.aborted;
export const reasonImpl = (sig) => sig.reason;
export const throwIfAbortedImpl = (sig) => sig.throwIfAborted();
