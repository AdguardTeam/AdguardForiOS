/* eslint-disable class-methods-use-this,no-console */

/**
 * Redefine if you need it
 */
const CURRENT_LEVEL: Level = 'DEBUG';

type Level = keyof typeof LEVELS;

const CONSOLE_METHODS = {
    LOG: 'log',
    INFO: 'info',
    ERROR: 'error',
} as const;

type ConsoleMethod = typeof CONSOLE_METHODS[keyof typeof CONSOLE_METHODS];

const LEVELS = {
    ERROR: 1,
    INFO: 2,
    DEBUG: 3,
} as const;

/**
 * Simple logger with log levels
 */
class Log {
    /**
     * Pretty-print javascript error
     */
    errorToString(error: Error) {
        return `${error.toString()}\nStack trace:\n${error.stack}`;
    }

    /**
     * Formats date to local time string
     * @param date
     */
    getLocalTimeString(date: Date) {
        const ONE_MINUTE_MS = 60 * 1000;
        const timeZoneOffsetMs = date.getTimezoneOffset() * ONE_MINUTE_MS;
        const localTime = new Date(date.getTime() - timeZoneOffsetMs);
        return localTime.toISOString().replace('Z', '');
    }

    /**
     * Prints log message
     */
    print(level: Level, method: ConsoleMethod, args: any[]) {
        // check log level
        if (LEVELS[CURRENT_LEVEL] < LEVELS[level]) {
            return;
        }
        if (!args || args.length === 0 || !args[0]) {
            return;
        }

        let formatted = args.map((arg) => {
            if (typeof arg !== 'undefined') {
                let value = arg;
                if (value instanceof Error) {
                    value = this.errorToString(value);
                } else if (value && value.message) {
                    value = value.message;
                } else if (typeof value === 'object') {
                    value = JSON.stringify(value, null, 4);
                }
                return value;
            }

            return arg;
        }).join(' ');

        formatted = `${this.getLocalTimeString(new Date())}: ${formatted}`;

        console[method](formatted);
    }

    debug(...args: any[]) {
        this.print('DEBUG', 'log', args);
    }

    info(...args: any[]) {
        this.print('INFO', 'info', args);
    }

    verboseInfo(verbose: boolean, ...args: any[]) {
        if (verbose) {
            this.info(args);
        }
    }

    error(...args: any[]) {
        this.print('ERROR', 'error', args);
    }
}

export const log = new Log();
