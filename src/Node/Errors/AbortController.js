const newImpl = () => new AbortController();
export { newImpl as new };
export const abortImpl = (controller) => controller.abort();
export const abortReasonImpl = (controller, reason) => controller.abort(reason);
export const signal = (controller) => controller.signal;
