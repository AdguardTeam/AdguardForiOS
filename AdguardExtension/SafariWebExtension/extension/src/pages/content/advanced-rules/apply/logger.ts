/**
 * Logs the `message` if `verbose` is true.
 *
 * @param verbose Flag to enable logging.
 * @param message Message to log.
 */
export const logMessage = (verbose: boolean, message: string) => {
    if (verbose) {
        // eslint-disable-next-line no-console
        console.log(`(AG) ${message}`);
    }
};
