import * as TSUrlFilter from '@adguard/tsurlfilter';
import {
    RequestType,
    MatchingResult,
    CosmeticOption,
    CosmeticResult,
} from '@adguard/tsurlfilter';

import { app } from '../../background/app';

/**
 * Class for filtering engine with all the loaded advanced rules.
 * Rules are loaded into the engine synchronously.
 */
export class EngineSync {
    engine: TSUrlFilter.Engine | undefined;

    /**
     * Starts the filtering engine with rules parsed from `rulesText`.
     *
     * @param rulesText Converted advanced rules joined into string.
     *
     * @returns Instance of engine.
     */
    start(rulesText: string): TSUrlFilter.Engine {
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

        this.engine = new TSUrlFilter.Engine(ruleStorage, true);

        // synchronously load the rules
        this.engine.loadRules();

        return this.engine;
    }
}

/**
 * Returns MatchingResult for the given `url`.
 *
 * @param url Page url.
 * @param engine Instance of engine.
 *
 * @returns TSUrlFilter's MatchingResult.
 */
const getMatchingResult = (url: string, engine: TSUrlFilter.Engine | undefined): MatchingResult => {
    if (!engine) {
        return new TSUrlFilter.MatchingResult([], null);
    }

    const request = new TSUrlFilter.Request(
        url,
        url,
        RequestType.Document,
    );

    // TODO: should here to be generated allowlist rule if necessary?
    const frameRule = null;

    return engine.matchRequest(request, frameRule);
};

/**
 * Returns CosmeticOption for the given `url`.
 * @param url Page url.
 * @param engine Instance of engine.
 *
 * @returns TSUrlFilter's CosmeticOption.
 */
export const getCosmeticOption = (url: string, engine: TSUrlFilter.Engine | undefined): CosmeticOption => {
    const matchingResult = getMatchingResult(url, engine);
    return matchingResult.getCosmeticOption();
};

/**
 * Returns CosmeticResult for the given `hostname`.
 *
 * @param hostname Hostname of the page.
 * @param cosmeticOption TSUrlFilter's CosmeticOption.
 * @param engine Instance of engine.
 *
 * @returns TSUrlFilter's CosmeticResult.
 */
export const getCosmeticResult = (
    hostname: string,
    cosmeticOption: CosmeticOption,
    engine: TSUrlFilter.Engine | undefined,
): CosmeticResult => {
    if (!engine) {
        return new TSUrlFilter.CosmeticResult();
    }

    const request = new TSUrlFilter.Request(hostname, null, TSUrlFilter.RequestType.Document);
    return engine.getCosmeticResult(request, cosmeticOption);
};
