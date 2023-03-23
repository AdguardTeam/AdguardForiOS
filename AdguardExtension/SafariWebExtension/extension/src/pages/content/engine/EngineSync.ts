import * as TSUrlFilter from '@adguard/tsurlfilter';
import {
    RequestType,
    MatchingResult,
    CosmeticOption,
    CosmeticResult,
} from '@adguard/tsurlfilter';

import { app } from '../../background/app';

// interface EngineSyncInterface {
//     engine: TSUrlFilter.Engine | undefined;
// }

/**
 * Class for filtering engine with all loaded advanced rules.
 * Rules are loaded into the engine synchronously.
 */
export class EngineSync {
    engine: TSUrlFilter.Engine | undefined;

    /**
     * Creates an instance of filtering engine with passed `rulesText`.
     * Loads rules into the engine synchronously.
     *
     * @param rulesText Converted advanced rules joined into a string.
     */
    constructor (rulesText: string) {
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
    }

    /**
     * Returns MatchingResult for the given `url`.
     *
     * @param url Page url.
     * @param engine Instance of engine.
     *
     * @returns TSUrlFilter's MatchingResult.
     */
    getMatchingResult = (url: string): MatchingResult => {
        if (!this.engine) {
            return new TSUrlFilter.MatchingResult([], null);
        }

        const request = new TSUrlFilter.Request(
            url,
            url,
            RequestType.Document,
        );

        // TODO should here to be generated allowlist rule if necessary?
        const frameRule = null;

        return this.engine.matchRequest(request, frameRule);
    };

    /**
     * Returns CosmeticOption for the given `url`.
     *
     * @param url Page url.
     * @param engine Instance of engine.
     *
     * @returns TSUrlFilter's CosmeticOption.
     */
    getCosmeticOption(url: string) {
        const matchingResult = this.getMatchingResult(url);
        return matchingResult.getCosmeticOption();
    }

    /**
     * Returns CosmeticResult for the specified `hostname` and cosmetic options
     * @param url Page url.
     * @param engine Instance of engine.
     *
     * @returns TSUrlFilter's CosmeticResult.
     */
    getCosmeticResult = (hostname: string, cosmeticOption: CosmeticOption) => {
        if (!this.engine) {
            return new TSUrlFilter.CosmeticResult();
        }

        const request = new TSUrlFilter.Request(hostname, null, TSUrlFilter.RequestType.Document);
        return this.engine.getCosmeticResult(request, cosmeticOption);
    };
}
