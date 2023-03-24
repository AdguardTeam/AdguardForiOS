import * as TSUrlFilter from '@adguard/tsurlfilter';

import { app } from '../../../../background/app';
import { getDomain } from '../../../../common/utils/url';

/**
 * Class for filtering engine with all loaded advanced rules.
 * Rules are loaded into the engine synchronously.
 */
export class EngineSync {
    engine: TSUrlFilter.Engine;

    /**
     * Creates an instance of filtering engine with passed `rulesText`.
     * Loads rules into the engine synchronously.
     *
     * @param rulesText Previously converted advanced rules joined into a string.
     */
    constructor(rulesText: string) {
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

        // load the rules synchronously
        this.engine.loadRules();
    }

    /**
     * Returns MatchingResult for the given `url`.
     *
     * @param url Frame url.
     * @param engineSync EngineSync instance.
     *
     * @returns TSUrlFilter's MatchingResult.
     */
    private static getMatchingResult = (url: string, engineSync: EngineSync): TSUrlFilter.MatchingResult => {
        const request = new TSUrlFilter.Request(
            url,
            url,
            TSUrlFilter.RequestType.Document,
        );

        const frameRule = null;

        return engineSync.engine.matchRequest(request, frameRule);
    };

    /**
     * Returns CosmeticOption for the given `url`.
     *
     * @param url Frame url.
     * @param engineSync EngineSync instance.
     *
     * @returns TSUrlFilter's CosmeticOption.
     */
    private static getCosmeticOption(url: string, engineSync: EngineSync): TSUrlFilter.CosmeticOption {
        const matchingResult = EngineSync.getMatchingResult(url, engineSync);
        return matchingResult.getCosmeticOption();
    }

    /**
     * Returns CosmeticResult for the specified `hostname` and cosmetic options.
     *
     * @param url Frame url.
     * @param engineSync EngineSync instance.
     *
     * @returns TSUrlFilter's CosmeticResult.
     */
    static getCosmeticResult = (url: string, engineSync: EngineSync): TSUrlFilter.CosmeticResult => {
        const hostname = getDomain(url);
        const request = new TSUrlFilter.Request(hostname, null, TSUrlFilter.RequestType.Document);

        const cosmeticOption = EngineSync.getCosmeticOption(url, engineSync);

        return engineSync.engine.getCosmeticResult(request, cosmeticOption);
    };
}
