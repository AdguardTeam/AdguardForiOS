import * as TSUrlFilter from '@adguard/tsurlfilter';

import { app } from '../../background/app';
import { getDomain } from '../../common/utils/url';

/**
 * Creates an instance of filtering engine with passed `rulesText`.
 * Loads rules into the engine synchronously.
 *
 * @param rulesText Previously converted advanced rules joined into a string.
 */
const createEngine = (rulesText: string) => {
    const FILTER_ID = 1;
    const rulesList = new TSUrlFilter.StringRuleList(
        FILTER_ID,
        rulesText,
        false,
        false,
        false,
    );
    const ruleStorage = new TSUrlFilter.RuleStorage([rulesList]);

    const config = {
        engine: 'extension',
        version: app.version,
        verbose: true,
        compatibility: TSUrlFilter.CompatibilityTypes.extension,
    };
    TSUrlFilter.setConfiguration(config);

    const engine = new TSUrlFilter.Engine(ruleStorage, true);

    // load the rules synchronously
    engine.loadRules();

    return engine;
};

/**
 * Returns MatchingResult for the given `url`.
 *
 * @param url Frame url.
 * @param engine Engine instance.
 *
 * @returns TSUrlFilter's MatchingResult.
 */
const getMatchingResult = (url: string, engine: TSUrlFilter.Engine): TSUrlFilter.MatchingResult => {
    const FRAME_URL = null;
    const request = new TSUrlFilter.Request(
        url,
        url,
        TSUrlFilter.RequestType.Document,
    );
    return engine.matchRequest(request, FRAME_URL);
};

/**
 * Returns CosmeticOption for the given `url`.
 *
 * @param url Frame url.
 * @param engine Engine instance.
 *
 * @returns TSUrlFilter's CosmeticOption.
 */
const getCosmeticOption = (url: string, engine: TSUrlFilter.Engine): TSUrlFilter.CosmeticOption => {
    const matchingResult = getMatchingResult(url, engine);
    return matchingResult.getCosmeticOption();
};

/**
 * Returns CosmeticResult for rules and specified frame url.
 *
 * @param rulesText Previously converted advanced rules joined into a string.
 * @param url Frame url.
 *
 * @returns TSUrlFilter's CosmeticResult.
 */
export const getEngineCosmeticResult = (rulesText: string, url: string): TSUrlFilter.CosmeticResult => {
    const hostname = getDomain(url);
    const request = new TSUrlFilter.Request(hostname, null, TSUrlFilter.RequestType.Document);

    const engine = createEngine(rulesText);
    const cosmeticOption = getCosmeticOption(url, engine);

    return engine.getCosmeticResult(request, cosmeticOption);
};
