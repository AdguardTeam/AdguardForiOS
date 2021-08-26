import _ from 'lodash';
import { validator } from '@adguard/translate';

import { log } from './log';
import { getLocaleTranslations } from './helpers';
import type { LocaleMessages } from './types';
import {
    BASE_LOCALE,
    LANGUAGES,
    REQUIRED_LOCALES,
    THRESHOLD_PERCENTAGE,
} from './constants';

const LOCALES = Object.keys(LANGUAGES);

/**
 * @typedef Result
 * @property {string} locale
 * @property {string} level % of translated
 * @property {Array} untranslatedStrings
 * @property {Array} invalidTranslations
 */

interface Result {
    locale: string,
    level: number,
    untranslatedStrings: string[],
    invalidTranslations: { key: string, error: string } []
}

/**
 * Logs translations readiness (default validation process)
 * @param {Result[]} results
 * @param {boolean} [isMinimum=false]
 */
const printTranslationsResults = (results: Result[], isMinimum = false) => {
    log.info('Translations readiness:');
    results.forEach((r) => {
        const record = `${r.locale} -- ${r.level}%`;
        if (r.level < THRESHOLD_PERCENTAGE) {
            log.warningRed(record);
            if (r.untranslatedStrings.length > 0) {
                log.warning('  untranslated:');
                r.untranslatedStrings.forEach((str) => {
                    log.warning(`    - ${str}`);
                });
            }
            if (!isMinimum) {
                if (r.invalidTranslations.length > 0) {
                    log.warning('  invalid:');
                    r.invalidTranslations.forEach((obj) => {
                        log.warning(`    - ${obj.key} -- ${obj.error}`);
                    });
                }
            }
        } else {
            log.success(record);
        }
    });
};

/**
 * Logs invalid translations (critical errors)
 * @param criticalResults
 */
const printCriticalResults = (criticalResults: Result[]) => {
    log.warning('Invalid translated string:');
    criticalResults.forEach((cr) => {
        log.warningRed(`${cr.locale}:`);
        cr.invalidTranslations.forEach((obj) => {
            log.warning(`   - ${obj.key} -- ${obj.error}`);
        });
    });
};

const validateMessage = (
    baseKey: string,
    baseLocaleTranslations: LocaleMessages,
    localeTranslations: LocaleMessages,
) => {
    const baseMessageValue = baseLocaleTranslations[baseKey].message;
    const localeMessageValue = localeTranslations[baseKey].message;
    try {
        validator.isTranslationValid(baseMessageValue, localeMessageValue);
        return undefined;
    } catch (error) {
        return { key: baseKey, error };
    }
};

/**
 * @typedef ValidationFlags
 * @property {boolean} [isMinimum=false] for minimum level of validation:
 * critical errors for all and full translations level for our locales
 * @property {boolean} [isInfo=false] for logging translations info without throwing the error
 */

interface ValidationFlags {
    isMinimum?: boolean,
    isInfo?: boolean,
}

/**
 * Checks locales translations readiness
 * @param {string[]} locales - list of locales
 * @param {ValidationFlags} flags
 * @returns {Result[]} array of object with such properties:
 * locale, level of translation readiness, untranslated strings array and array
 * of invalid translations
 */
export const checkTranslations = async (locales: string[], flags: ValidationFlags) => {
    const { isMinimum = false, isInfo = false } = flags;
    const baseLocaleTranslations = await getLocaleTranslations(BASE_LOCALE);
    const baseMessages = Object.keys(baseLocaleTranslations);
    const baseMessagesCount = baseMessages.length;

    const translationResults = await Promise.all(locales.map(async (locale: string) => {
        const localeTranslations = await getLocaleTranslations(locale);
        const localeMessages = Object.keys(localeTranslations);
        const localeMessagesCount = localeMessages.length;

        const untranslatedStrings: string[] = [];
        const invalidTranslations: { key: string, error: string }[] = [];
        baseMessages.forEach((baseKey) => {
            if (!localeMessages.includes(baseKey)) {
                untranslatedStrings.push(baseKey);
            } else {
                const validationError = validateMessage(
                    baseKey,
                    baseLocaleTranslations,
                    localeTranslations,
                );
                if (validationError) {
                    invalidTranslations.push(validationError);
                }
            }
        });

        const validLocaleMessagesCount = localeMessagesCount - invalidTranslations.length;

        const strictLevel = ((validLocaleMessagesCount / baseMessagesCount) * 100);
        const level = Math.round((strictLevel + Number.EPSILON) * 100) / 100;

        return {
            locale, level, untranslatedStrings, invalidTranslations,
        };
    }));

    const filteredCriticalResults = translationResults.filter((result) => {
        return result.invalidTranslations.length > 0;
    });

    const filteredReadinessResults = translationResults.filter((result) => {
        return isMinimum
            ? result.level < THRESHOLD_PERCENTAGE && REQUIRED_LOCALES.includes(result.locale)
            : result.level < THRESHOLD_PERCENTAGE;
    });

    if (isInfo) {
        printTranslationsResults(translationResults);
    } else {
        // critical errors and required locales translations levels check
        if (isMinimum) {
            let isSuccess = true;
            // check for invalid strings
            if (filteredCriticalResults.length === 0) {
                log.success('No invalid translations found');
            } else {
                isSuccess = false;
                printCriticalResults(filteredCriticalResults);
                log.warningRed('Locales above should not have invalid strings');
            }
            // check for translations readiness for required locales
            if (filteredReadinessResults.length === 0) {
                log.success('Our locales have required level of translations');
            } else {
                isSuccess = false;
                printTranslationsResults(filteredReadinessResults, isMinimum);
                log.warningRed('Our locales should be done for 100%');
            }
            if (!isSuccess) {
                // throw error finally
                throw new Error('Locales validation failed!');
            }
        }
        // common translations check
        if (filteredReadinessResults.length === 0) {
            let message = `Level of translations is required for locales: ${locales.join(', ')}`;
            if (_.isEqual(locales, LOCALES)) {
                message = 'All locales have required level of translations';
            }
            log.success(message);
        } else {
            printTranslationsResults(filteredReadinessResults);
            throw new Error('Locales above should be done for 100%');
        }
    }

    return translationResults;
};
