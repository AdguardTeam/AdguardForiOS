/* eslint-disable */
import { promises as fs } from 'fs';
import path from 'path';
import _ from 'lodash';

import { log } from './log';
import { getLocaleTranslations } from './helpers';
import {
    BASE_LOCALE,
    LOCALES_RELATIVE_PATH,
    LOCALE_DATA_FILENAME,
    SRC_RELATIVE_PATH,
    SRC_FILENAME_EXTENSIONS,
    PERSISTENT_MESSAGES,
} from './constants';

const LOCALES_DIR = path.resolve(__dirname, LOCALES_RELATIVE_PATH);
const SRC_DIR = path.resolve(__dirname, SRC_RELATIVE_PATH);

/**
 * Search configuration
 */
const configuration = {
    src: path.join(LOCALES_DIR, `${BASE_LOCALE}/${LOCALE_DATA_FILENAME}`), // Base language json
    targets: [SRC_DIR], // Directory to search occurrences
    output: path.join(LOCALES_DIR, `${BASE_LOCALE}/${LOCALE_DATA_FILENAME}`), // Place to put result
    filesReg: `(${SRC_FILENAME_EXTENSIONS.join('|')})$`,
    // messages used in extensions localisations e.g. __MSG_short_name__
    persistedMessages: PERSISTENT_MESSAGES,
};

/**
 * Promise wrapper for writing in file
 *
 * @param {string} filename
 * @param {*} rawContent
 */
const writeInFile = async <T>(filename: string, rawContent: T) => {
    let content;
    if (typeof rawContent !== 'string') {
        content = JSON.stringify(rawContent, null, 4);
    } else {
        content = rawContent;
    }
    await fs.writeFile(filename, content);
};

/**
 * Finds files paths within directory corresponding to filesPattern
 * @param {string} dir
 * @param {string} filesPattern
 * @returns {Promise<*>}
 */
const findFilesPaths = async (dir: string, filesPattern: string) => {
    const filterRegexp = new RegExp(filesPattern);
    const walk = async (dir: string, filePaths: string[] = []) => {
        const files = await fs.readdir(dir);

        for (const file of files) {
            const filePath = path.join(dir, file);
            const stat = await fs.stat(filePath);

            if (stat.isDirectory()) {
                filePaths = await walk(filePath, filePaths);
            } else if (filePath.match(filterRegexp)) {
                filePaths.push(filePath);
            }
        }
        return filePaths;
    };
    return walk(dir);
};

const getFilesPathsList = async (targets: string[], filesPattern: string) => {
    const filesListsPromises = targets.map(async (directory) => {
        return findFilesPaths(directory, filesPattern);
    });

    const filesLists = await Promise.all(filesListsPromises)

    return filesLists.reduce((uniqueFiles, filesList) => {
        return [...new Set([...uniqueFiles, ...filesList])];
    }, []);
};

const filterMessages = (messages: string[], content: string) => {
    return messages.filter((message) => {
        return content.indexOf(message) > -1;
    });
};

const chooseMessagesFromFiles = async (messages: string[], targets: string[], filesReg: string) => {
    const filesPaths = await getFilesPathsList(targets, filesReg);

    const filteredMessagesPromises = filesPaths.map(async (filePath) => {
        const fileContent = await fs.readFile(filePath, 'utf-8');
        return filterMessages(messages, fileContent);
    });

    const filteredMessages = await Promise.all(filteredMessagesPromises);
    const flattenMessages = filteredMessages.flat();
    const uniqMessages = [...new Set(flattenMessages)];
    return uniqMessages;
};

/**
 * Initialization of search process
 */
export const renew = async () => {
    let { targets } = configuration;
    const {
        src,
        output = 'result.json',
        filesReg = '.html$',
        persistedMessages = [],
    } = configuration;

    if (!src) {
        throw new Error('No source path');
    }

    if (!targets || !targets.length) {
        throw new Error('No target directories');
    }

    if (typeof targets === 'string') {
        targets = [targets];
    }

    const source = await getLocaleTranslations(BASE_LOCALE);
    const oldKeys = Object.keys({ ...source });

    try {
        const chosenKeys = await chooseMessagesFromFiles(oldKeys, targets, filesReg)
        const result: { [key: string]: string } = {};
        const resultMessages = _.uniq([...chosenKeys, ...persistedMessages]);

        resultMessages.forEach((key) => {
            result[key] = source[key];
        });

        const removedKeys = _.xor(resultMessages, oldKeys);
        if (removedKeys.length === 0) {
            log.info('There is nothing to renew');
        } else {
            await writeInFile(output, result);
            log.info(`existing keys number: ${resultMessages.length}`);
            log.info(`old keys number: ${oldKeys.length}`);
            log.warningRed(`${removedKeys.length} keys have been removed:`);
            log.warning(` - ${removedKeys.join('\n - ')}`);
        }
    } catch (e) {
        log.error(e);
    }
};
