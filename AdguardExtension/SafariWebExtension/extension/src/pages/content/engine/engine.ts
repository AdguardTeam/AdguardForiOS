import {
    StringRuleList,
    RuleStorage,
    CompatibilityTypes,
    setConfiguration,
    Engine,
    Request,
    RequestType,
    MatchingResult,
    CosmeticResult,
} from '@adguard/tsurlfilter';

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
    const rulesList = new StringRuleList(
        FILTER_ID,
        rulesText,
        false,
        false,
        false,
    );
    const ruleStorage = new RuleStorage([rulesList]);

    const config = {
        engine: 'extension',
        version: app.version,
        verbose: true,
        compatibility: CompatibilityTypes.extension,
    };
    setConfiguration(config);

    const engine = new Engine(ruleStorage, true);

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
const getMatchingResult = (url: string, engine: Engine): MatchingResult => {
    /**
     * We do not need to pass real referrer to `matchRequest()`
     * when selecting cosmetic rules for the current page,
     * cosmetic rules do not depend on where the user navigated from.
     */
    const FRAME_URL = null;
    const request = new Request(
        url,
        url,
        RequestType.Document,
    );
    return engine.matchRequest(request, FRAME_URL);
};

/**
 * Returns CosmeticResult for rules and specified frame url.
 *
 * @param rulesText Previously converted advanced rules joined into a string.
 * @param url Frame url.
 *
 * @returns TSUrlFilter's CosmeticResult.
 */
export const getEngineCosmeticResult = (rulesText: string, url: string): CosmeticResult => {
    const hostname = getDomain(url);
    const request = new Request(hostname, null, RequestType.Document);

    const engine = createEngine(rulesText);
    const matchingResult = getMatchingResult(url, engine);
    const cosmeticOption = matchingResult.getCosmeticOption();

    return engine.getCosmeticResult(request, cosmeticOption);
};
