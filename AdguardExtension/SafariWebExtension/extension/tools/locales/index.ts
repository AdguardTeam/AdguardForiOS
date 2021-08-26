/* eslint-disable no-console */
import { program } from 'commander';

import { downloadAndSave } from './download';
import { upload } from './upload';
import { renew } from './renew';
import { checkTranslations } from './validate';
import { checkUnusedMessages } from './unused';
import { LANGUAGES } from './constants';
import { log } from './log';

const LOCALES = Object.keys(LANGUAGES);

const download = async (locales: string[]) => {
    try {
        await downloadAndSave(locales);
        log.success('Download was successful');
    } catch (e) {
        log.error(e.message);
        process.exit(1);
    }
};

const uploadBaseLocale = async () => {
    try {
        // check for unused base-locale strings before uploading
        await checkUnusedMessages();
        const result = await upload();
        log.success(`Upload was successful with response: ${JSON.stringify(result)}`);
    } catch (e) {
        log.error(e.message);
        process.exit(1);
    }
};

const renewLocales = async () => {
    try {
        await renew();
    } catch (e) {
        log.error(e.message);
        process.exit(1);
    }
};

const validate = async (locales: string[], isMinimum?: boolean) => {
    try {
        await checkTranslations(locales, { isMinimum });
    } catch (e) {
        log.error(e.message);
        process.exit(1);
    }
};

const summary = async (isInfo: boolean) => {
    try {
        await checkTranslations(LOCALES, { isInfo });
    } catch (e) {
        log.error(e.message);
        process.exit(1);
    }
};

const unused = async () => {
    try {
        await checkUnusedMessages();
    } catch (e) {
        log.error(e.message);
        process.exit(1);
    }
};

program
    .command('download')
    .description('Downloads messages from localization service')
    .option('-l,--locales [list...]', 'specific list of space-separated locales')
    .action(async (opts) => {
        // defaults to download all locales
        // and validate: all for critical errors and ours for full translations readiness
        let locales = LOCALES;
        let isMinimum = true;
        // but if list_of_locales is specified, use them for download and validation
        if (opts.locales && opts.locales.length > 0) {
            locales = opts.locales;
            isMinimum = false;
        }
        await download(locales);
        await validate(locales, isMinimum);
    });

program
    .command('upload')
    .description('Uploads base messages to the localization service')
    .action(uploadBaseLocale);

program
    .command('renew')
    .description('Removes old messages from locale messages')
    .action(renewLocales);

program
    .command('validate')
    .description('Validates translations')
    .option('-R,--min', 'for critical errors of all locales and translations readiness of ours')
    .option('-l,--locales [list...]', 'for specific list of space-separated locales')
    .action((opts) => {
        // defaults to validate all locales
        let locales = LOCALES;
        let isMinimum;
        if (opts.min) {
            isMinimum = true;
        } else if (opts.locales && opts.locales.length > 0) {
            locales = opts.locales;
        }
        validate(locales, isMinimum);
    });

program
    .command('info')
    .description('Shows locales info')
    .option('-s,--summary', 'for all locales translations readiness')
    .option('-N,--unused', 'for unused base-lang strings')
    .action((opts) => {
        const IS_INFO = true;
        if (opts.summary) {
            summary(IS_INFO);
        } else if (opts.unused) {
            unused();
        } else if (!opts.summary && !opts.unused) {
            summary(IS_INFO);
            unused();
        }
    });

program.parse(process.argv);
