import { CosmeticResult } from '@adguard/tsurlfilter';

import { buildStyleSheet } from './css-service';

import { SelectorsAndScripts } from '../../common/interfaces';

/**
 * Returns advanced rules data in needed format.
 *
 * @param cosmeticResult TSUrlFilter's CosmeticResult.
 * @param url Frame url.
 * @param [verbose=false] Flag to enable logging.
 *
 * @returns Properly sorted selectors and scripts.
 */
export const prepareAdvancedRules = (
    cosmeticResult: CosmeticResult,
    url: string,
    verbose = false,
): SelectorsAndScripts => {
    const injectCssRules = [
        ...cosmeticResult.CSS.generic,
        ...cosmeticResult.CSS.specific,
    ];

    const elementHidingExtCssRules = [
        ...cosmeticResult.elementHiding.genericExtCss,
        ...cosmeticResult.elementHiding.specificExtCss,
    ];

    const injectExtCssRules = [
        ...cosmeticResult.CSS.genericExtCss,
        ...cosmeticResult.CSS.specificExtCss,
    ];

    const cssInject = buildStyleSheet([], injectCssRules, true);

    const cssExtended = buildStyleSheet(
        elementHidingExtCssRules,
        injectExtCssRules,
        false,
    );

    const scriptRules = cosmeticResult.getScriptRules();

    const scripts: string[] = [];
    scriptRules.forEach((scriptRule) => {
        const script = scriptRule.getScript({
            debug: verbose,
            request: {
                domain: url,
            },
        });
        if (script !== null) {
            scripts.push(script);
        }
    });

    // remove repeating scripts
    const uniqueScripts = [...new Set(scripts)];

    return {
        scripts: uniqueScripts,
        cssInject,
        cssExtended,
    };
};
