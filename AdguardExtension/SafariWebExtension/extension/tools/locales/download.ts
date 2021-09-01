/* eslint-disable @typescript-eslint/no-shadow */
/**
 * This task updates locales in repository
 */
import axios from 'axios';
import path from 'path';
import fs from 'fs';
import querystring from 'querystring';
import _ from 'lodash';

import { log } from './log';
import { getLocaleTranslations } from './helpers';

import {
    PROJECT_ID,
    BASE_LOCALE,
    LANGUAGES,
    LOCALE_PAIRS,
    API_URL,
    LOCALES_RELATIVE_PATH,
    FORMAT,
    LOCALE_DATA_FILENAME,
    PERSISTENT_MESSAGES,
} from './constants';
import { LocaleMessages } from './types';

const LOCALES_DOWNLOAD_URL = `${API_URL}/download`;
const LOCALES_DIR = path.resolve(__dirname, LOCALES_RELATIVE_PATH);

const locales = Object.keys(LANGUAGES);

const downloadMessagesByUrl = async (url: string) => {
    let response;
    try {
        log.info(`Downloading url: ${url}...`);
        response = await axios.get(url, { responseType: 'arraybuffer' });
        log.info(`Downloaded: ${url}`);
    } catch (e: any) {
        let errorMessage;
        if (e.response && e.response.data) {
            const decoder = new TextDecoder();
            errorMessage = decoder.decode(e.response.data);
        } else {
            errorMessage = e.message;
        }
        log.error(`Error occurred: ${errorMessage}, while downloading: ${url}`);
    }
    return response ? response.data : null;
};

const getQueryString = (lang: string) => {
    const options = {
        project: PROJECT_ID,
        language: lang,
        format: FORMAT,
        filename: LOCALE_DATA_FILENAME,
    };
    return querystring.stringify(options);
};

const promiseBatchMap = async (
    arr: any[],
    batchSize: number,
    handler: (arg: any) => Promise<any>,
) => {
    const batches = _.chunk(arr, batchSize);

    const result = [];

    // eslint-disable-next-line no-restricted-syntax
    for (const batch of batches) {
        const promises = batch.map(handler);
        // eslint-disable-next-line no-await-in-loop
        const data = await Promise.all(promises);
        result.push(data);
    }

    return result.flat(Infinity);
};

const downloadLocales = async (locales: string[]) => {
    const localeUrlPairs = locales.map((locale) => {
        const crowdinLocale = LOCALE_PAIRS[locale] || locale;
        const downloadUrl = `${LOCALES_DOWNLOAD_URL}?${getQueryString(crowdinLocale)}`;
        return { locale, url: downloadUrl };
    });

    // Decrease this value if you encounter error:
    // "Maximum number of concurrent requests for this endpoint is reached"
    const LOCALES_DOWNLOAD_BATCH_SIZE = 20;

    const handler = async (localeUrlPair: { locale: string, url: string }) => {
        const { locale, url } = localeUrlPair;
        const data = await downloadMessagesByUrl(url);
        return { locale, data };
    };

    return promiseBatchMap(localeUrlPairs, LOCALES_DOWNLOAD_BATCH_SIZE, handler);
};

const saveFile = async (path: string, data: string) => {
    try {
        await fs.promises.writeFile(path, data);
    } catch (e: any) {
        log.error(`Was unable do save data in path: ${path}. Error: ${e.message}`);
    }
};

interface LocaleData {
    locale: string,
    data: string,
}

const saveLocales = async (localeDataPairs: LocaleData[]) => {
    const promises = localeDataPairs.map((localeDataPair) => {
        const { locale, data } = localeDataPair;
        const localeFilePath = path.join(LOCALES_DIR, locale, LOCALE_DATA_FILENAME);
        const localeDirPath = path.join(LOCALES_DIR, locale);
        if (!fs.existsSync(localeDirPath)) {
            fs.mkdirSync(localeDirPath);
        }
        return saveFile(localeFilePath, data);
    });

    return Promise.all(promises);
};

/**
 * Checks messages for required locales, if doesn't find them, then adds from baseMessages
 * @param {string} locale - locale
 * @param {Object} messages - locale messages
 * @param {Object} baseMessages - base locale messages
 */
const checkRequiredFields = (
    locale: string,
    messages: LocaleMessages,
    baseMessages: LocaleMessages,
) => {
    const requiredFields = PERSISTENT_MESSAGES;
    const resultMessages = { ...messages };
    requiredFields.forEach((requiredField) => {
        const fieldData = resultMessages[requiredField];
        if (!fieldData) {
            log.info(` - "${locale}" locale doesn't have required field: "${requiredField}"`);
            log.info('   Will be added message from base locale');
            resultMessages[requiredField] = baseMessages[requiredField];
        }
    });
    return resultMessages;
};

const validateRequiredFields = async () => {
    const baseMessages = await getLocaleTranslations(BASE_LOCALE);
    const promises = locales.map(async (locale) => {
        const pathToLocale = path.join(LOCALES_DIR, locale, LOCALE_DATA_FILENAME);
        const messages = JSON.parse(await fs.promises.readFile(pathToLocale, 'utf-8'));
        const checkedMessages = checkRequiredFields(locale, messages, baseMessages);
        const checkedMessagesString = JSON.stringify(checkedMessages, null, 4).replace(/\//g, '\\/');
        await fs.promises.writeFile(pathToLocale, checkedMessagesString);
    });
    await Promise.all(promises).catch((e) => {
        log.error(e);
    });
};

export const downloadAndSave = async (locales: string[]) => {
    const localeDataPairs = await downloadLocales(locales);
    await saveLocales(localeDataPairs);
    await validateRequiredFields();
};
