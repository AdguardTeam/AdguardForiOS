import { EngineSync } from './engine';
import { buildStyleSheet } from './css-service';

import { SelectorsAndScripts } from '../../../common/interfaces';

/**
 * Returns advanced rules data in needed format.
 *
 * @param url Frame url.
 * @param convertedRulesText Previously converted advanced rules joined into a string.
 *
 * @returns Properly sorted selectors and scripts.
 */
export const prepareAdvancedRules = (url: string, convertedRulesText: string): SelectorsAndScripts => {
    const engine = new EngineSync(convertedRulesText);
    const cosmeticResult = engine.getCosmeticResult(url);

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

    const debug = false;
    const scripts: string[] = scriptRules
        // FIXME: use one array method to get scripts
        .map((scriptRule) => scriptRule.getScript({
            debug,
            request: {
                domain: url,
            },
        }))
        .filter((script): script is string => script !== null);

    // remove repeating scripts
    const uniqueScripts = [...new Set(scripts)];

    return {
        scripts: uniqueScripts,
        cssInject,
        cssExtended,
    };
};
