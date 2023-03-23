import { EngineSync } from './engine';
import { buildStyleSheet } from './css-service';

import { getDomain } from '../common/utils/url';
import { SelectorsAndScripts } from '../common/interfaces';

/**
 * Returns the instance of started sync engine.
 *
 * @param convertedRulesText Converted advanced rules joined into string.
 *
 * @returns Instance of engine.
 */
const getEngine = (convertedRulesText: string): EngineSync => {
    const engineSync = new EngineSync(convertedRulesText);
    return engineSync;
};

/**
 * Returns advanced rules data into needed format.
 *
 * @param url Page url.
 * @param convertedRulesText Converted advanced rules joined into string.
 *
 * @returns Properly sorted selectors and scripts.
 */
export const getAdvancedRulesData = (url: string, convertedRulesText: string): SelectorsAndScripts => {
    const engine = getEngine(convertedRulesText);
    const cosmeticOption = engine.getCosmeticOption(url);

    const hostname = getDomain(url);
    const cosmeticResult = engine.getCosmeticResult(hostname, cosmeticOption);

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
