import React from 'react';
import { I18nInterface, translate } from '@adguard/translate';
import { i18n } from './i18n';

/**
 * Retrieves localised messages by key, formats and converts into react components or string
 */
export const reactTranslator = translate.createReactTranslator(<I18nInterface>i18n, React);
