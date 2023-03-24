import * as TSUrlFilter from '@adguard/tsurlfilter';

import { app } from '../../../../background/app';
import { getDomain } from '../../../../common/utils/url';

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
     *
     * @returns TSUrlFilter's MatchingResult.
     */
    private getMatchingResult = (url: string): TSUrlFilter.MatchingResult => {
        if (!this.engine) {
            return new TSUrlFilter.MatchingResult([], null);
        }

        const request = new TSUrlFilter.Request(
            url,
            url,
            TSUrlFilter.RequestType.Document,
        );

        // TODO should here to be generated allowlist rule if necessary?
        const frameRule = null;

        return this.engine.matchRequest(request, frameRule);
    };

    /**
     * Returns CosmeticOption for the given `url`.
     *
     * @param url Frame url.
     *
     * @returns TSUrlFilter's CosmeticOption.
     */
    private getCosmeticOption(url: string): TSUrlFilter.CosmeticOption {
        const matchingResult = this.getMatchingResult(url);
        return matchingResult.getCosmeticOption();
    }

    /**
     * Returns CosmeticResult for the specified `hostname` and cosmetic options.
     *
     * @param url Frame url.
     *
     * @returns TSUrlFilter's CosmeticResult.
     */
    getCosmeticResult = (url: string): TSUrlFilter.CosmeticResult => {
        if (!this.engine) {
            return new TSUrlFilter.CosmeticResult();
        }

        const hostname = getDomain(url);
        const request = new TSUrlFilter.Request(hostname, null, TSUrlFilter.RequestType.Document);

        const cosmeticOption = this.getCosmeticOption(url);

        return this.engine.getCosmeticResult(request, cosmeticOption);
    };
}
