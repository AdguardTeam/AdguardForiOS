import { ExtendedCss } from '@adguard/extended-css';

import { log } from '../../common/log';

/**
 * Applies Extended Css stylesheet.
 *
 * @param extendedCss Array with ExtendedCss stylesheets.
 */
export const applyExtendedCss = (extendedCss: string[]) => {
    if (!extendedCss || !extendedCss.length) {
        return;
    }

    log.debug(`extended css length: ${extendedCss.length}`);
    /**
     * TODO: use `cssRules` ExtendedCss config property for array of rules instead of `styleSheet`
     * {@see https://github.com/AdguardTeam/ExtendedCss/#ext-css-configuration-interface};
     * buildStyleSheet() may be refactored during this task. AG-20907.
     *
     * TODO: instead of `extendedCss.filter().map().map().join()` use `forEach()` loop
     * so the array will be traversed only once.
     */
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
