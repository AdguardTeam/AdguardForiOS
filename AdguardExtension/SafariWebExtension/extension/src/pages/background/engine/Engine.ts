import * as TSUrlFilter from '@adguard/tsurlfilter';
import { CosmeticOption, RequestType } from '@adguard/tsurlfilter';

import { app } from '../app';

/**
 * Sync engine.
 */
export class EngineSync {
    engine: TSUrlFilter.Engine | undefined;

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

const getMatchingResult = (url: string, engine: TSUrlFilter.Engine | undefined) => {
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

export const getCosmeticOption = (url: string, engine: TSUrlFilter.Engine | undefined) => {
    const matchingResult = getMatchingResult(url, engine);
    return matchingResult.getCosmeticOption();
}

export const getCosmeticResult = (
    hostname: string,
    cosmeticOption: CosmeticOption,
    engine: TSUrlFilter.Engine | undefined,
) => {
    if (!engine) {
        return new TSUrlFilter.CosmeticResult();
    }

    const request = new TSUrlFilter.Request(hostname, null, TSUrlFilter.RequestType.Document);
    return engine.getCosmeticResult(request, cosmeticOption);
};
