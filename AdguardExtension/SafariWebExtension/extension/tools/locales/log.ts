/* eslint-disable no-console */
import chalk from 'chalk';

const info = (text?: string) => {
    if (text) {
        console.log(text);
    } else {
        console.log('Unknown info');
    }
};

const success = (text: string) => {
    if (text) {
        console.log(chalk.green.bgBlack(text));
    } else {
        info();
    }
};

const warning = (text: string) => {
    if (text) {
        console.log(chalk.black.bgYellowBright(text));
    } else {
        info();
    }
};

const warningRed = (text: string) => {
    if (text) {
        console.log(chalk.bold.yellow.bgRed(text));
    } else {
        info();
    }
};

const error = (text: string) => {
    if (text) {
        console.log(chalk.bold.yellow.bgRed(text));
        throw new Error(text);
    } else {
        throw new Error('Unknown error');
    }
};

export const log = {
    info,
    success,
    warning,
    warningRed,
    error,
};
