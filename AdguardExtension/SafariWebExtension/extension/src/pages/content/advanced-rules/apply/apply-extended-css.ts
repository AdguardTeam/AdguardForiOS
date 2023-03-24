import { ExtendedCss } from '@adguard/extended-css';

import { logMessage } from './logger';

/**
 * Applies Extended Css stylesheet.
 *
 * @param extendedCss Array with ExtendedCss stylesheets.
 * @param verbose Flag to enable logging.
 */
export const applyExtendedCss = (extendedCss: string[], verbose: boolean) => {
    if (!extendedCss || !extendedCss.length) {
        return;
    }

    logMessage(verbose, `extended css length: ${extendedCss.length}`);
    const cssRules = extendedCss
        .filter((s) => s.length > 0)
        .map((s) => s.trim())
        .map((s) => {
            return s[s.length - 1] !== '}'
                ? `${s} {display:none!important;}`
                : s;
        });
    const extCss = new ExtendedCss({ cssRules });
    extCss.apply();
};
