import * as TSUrlFilter from '@adguard/tsurlfilter';

import { app } from '../app';

export class Engine {
    engine: TSUrlFilter.Engine | undefined;

    async start(rulesText: string): Promise<TSUrlFilter.Engine> {
        const FILTER_ID = 1;
        const ASYNC_LOAD_CHUNK_SIZE = 5000;

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

        /*
         * UI thread becomes blocked on the options page while request filter is created
         * that's why we create filter rules using chunks of the specified length
         * Request filter creation is rather slow operation so we should
         * use setTimeout calls to give UI thread some time.
        */
        await this.engine.loadRulesAsync(ASYNC_LOAD_CHUNK_SIZE);

        return this.engine;
    }

    /**
     * Gets cosmetic result for the specified hostname and cosmetic options
     */
    getCosmeticResult = (hostname: string) => {
        if (!this.engine) {
            return new TSUrlFilter.CosmeticResult();
        }

        const request = new TSUrlFilter.Request(hostname, null, TSUrlFilter.RequestType.Document);
        return this.engine.getCosmeticResult(request, TSUrlFilter.CosmeticOption.CosmeticOptionAll);
    };
}
