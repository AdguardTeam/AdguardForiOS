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
    // TODO: use cssRules for ExtendedCss, buildStyleSheet() may be refactored
    // TODO: use one array method for `cssRules` preparing
    const styleSheet = extendedCss
        .filter((s) => s.length > 0)
        .map((s) => s.trim())
        .map((s) => {
            return s[s.length - 1] !== '}'
                ? `${s} {display:none!important;}`
                : s;
        })
        .join('\n');
    const extCss = new ExtendedCss({ styleSheet });
    extCss.apply();
};
