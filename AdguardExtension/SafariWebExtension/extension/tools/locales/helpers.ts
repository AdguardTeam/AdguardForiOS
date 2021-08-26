import path from 'path';
import fs from 'fs';

import { LOCALE_DATA_FILENAME, LOCALES_ABSOLUTE_PATH } from './constants';

/**
 * Gets strings for certain locale
 * @param {string} locale
 * @returns {Object}
 */
export const getLocaleTranslations = async (locale: string) => {
    const filePath = path.join(LOCALES_ABSOLUTE_PATH, locale, LOCALE_DATA_FILENAME);
    const fileContent = await fs.promises.readFile(filePath, 'utf-8');
    return JSON.parse(fileContent);
};
