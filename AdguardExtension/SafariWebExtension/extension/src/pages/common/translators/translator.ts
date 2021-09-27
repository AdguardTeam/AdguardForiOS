import { I18nInterface, translate } from '@adguard/translate';
import { i18n } from './i18n';

/**
 * Retrieves localised message by key, formats it and converts into string
 */
export const translator = translate.createTranslator(<I18nInterface>i18n);
