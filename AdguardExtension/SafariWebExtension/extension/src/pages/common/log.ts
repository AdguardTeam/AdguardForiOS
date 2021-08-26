// TODO switch to a less verbose level later
const CURRENT_LEVEL = 'DEBUG';

declare global {
    interface Console {
        [key: string]: ConsoleMethod;
    }
}

const LEVELS = {
    ERROR: 1,
    INFO: 2,
    DEBUG: 3,
} as const;

type Level = keyof typeof LEVELS;

const CONSOLE_METHODS = {
    LOG: 'log',
    INFO: 'info',
    ERROR: 'error',
} as const;

type ConsoleMethod = typeof CONSOLE_METHODS[keyof typeof CONSOLE_METHODS];

const print = (level: Level, method: ConsoleMethod, args: string[]) => {
    // check log level
    if (LEVELS[CURRENT_LEVEL] < LEVELS[level]) {
        return;
    }

    const now = new Date();
    const formatted = `${now.toISOString()}:`;
    // eslint-disable-next-line no-console
    console[method](formatted, ...args);
};

// TODO make possible to log objects or another complicated objects like errors
export const log = {
    debug(...args: any[]) {
        print('DEBUG', 'log', args);
    },

    info(...args: any[]) {
        print('INFO', 'info', args);
    },

    error(...args: any[]) {
        print('ERROR', 'error', args);
    },
};
