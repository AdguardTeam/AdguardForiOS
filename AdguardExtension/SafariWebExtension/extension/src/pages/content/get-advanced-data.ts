import * as TSUrlFilter from '@adguard/tsurlfilter';

import { EngineSync, getCosmeticOption, getCosmeticResult } from './engine';
import { buildStyleSheet } from './css-service';

import { getDomain } from '../common/utils/url';
import { SelectorsAndScripts } from '../common/interfaces';

const getEngine = (() => {
    const engine = new EngineSync();

    const start = (convertedRulesText: string): EngineSync => {
        engine.start(convertedRulesText);
        return engine;
    };

    return (convertedRulesText: string): TSUrlFilter.Engine | undefined => start(convertedRulesText).engine;
})();

export const getAdvancedData = (url: string, convertedRulesText: string): SelectorsAndScripts => {
    const engine = getEngine(convertedRulesText);
    const hostname = getDomain(url);
    const cosmeticOption = getCosmeticOption(url, engine);

    const cosmeticResult = getCosmeticResult(hostname, cosmeticOption, engine);

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
