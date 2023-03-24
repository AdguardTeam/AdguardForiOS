import browser from 'webextension-polyfill';

import { getAdvancedRulesText } from './rule-storage';
import { getEngineCosmeticResult } from './engine';
import { prepareAdvancedRules } from './prepare-rules';
import { applyAdvancedRules } from './apply-rules';

import { log } from '../common/log';
import { MessagesToBackgroundPage } from '../common/constants';

/**
 * Sends empty message to background page just to wake it up.
 * This is the way to ensure that advanced rules are updated and set to storage there
 * before getting them from storage.
 */
const wakeBackgroundPage = async (): Promise<void> => {
    try {
        await browser.runtime.sendMessage({
            type: MessagesToBackgroundPage.WakeUp,
            data: {},
        });
    } catch (e) {
        log.info('Could not wake up background page due to', e);
    }
};

const init = async () => {
    if (document instanceof HTMLDocument) {
        const frameUrl = window.location.href;
        if (frameUrl && frameUrl.indexOf('http') === 0) {
            /**
             * Wake background page to force the advanced rules update from native host.
             *
             * IMPORTANT: it should not be 'await wakeBackgroundPage()'
             * because it will postpone the execution of the following code and it is not needed.
             * We need to apply the rules as soon as possible.
             */
            wakeBackgroundPage();

            let rulesText;
            const startTime = performance.now();
            try {
                rulesText = await getAdvancedRulesText();
            } catch (e) {
                log.error(e);
            }
            if (!rulesText) {
                log.info('AG: no scripts and selectors found');
                return;
            }

            log.info(`Time to get advanced rules in content script: ${performance.now() - startTime} ms`);

            const cosmeticResult = getEngineCosmeticResult(rulesText, frameUrl);
            const selectorsAndScripts = prepareAdvancedRules(cosmeticResult, frameUrl);
            applyAdvancedRules(selectorsAndScripts, frameUrl);
        }
    }
};

export const content = {
    init,
};
