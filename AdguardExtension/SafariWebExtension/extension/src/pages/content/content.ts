/**
 * @file
 *
 * Earlier the engine was created once on the background page
 * for advanced rules conversion (1) into a string
 * and preparation (2) into {@link SelectorsAndScripts} data format —
 * the engine is needed for the _preparation_.
 * And content script requested this data by messaging and applied it.
 *
 * The main problem was that the messaging from content script to background page and back
 * took too much time comparing to storage access.
 * So we decided to avoid the messaging when it is possible
 * and create an engine instance in content script.
 *
 * Now the advanced rules are previously converted into a string (1)
 * and set to the storage on the background page,
 * and later in the content script we get the string from the storage,
 * create an engine instance for advanced rule preparation (2), and apply them.
 */

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
        });
    } catch (e) {
        log.info('Could not wake up background page due to error:', e);
    }
};

const init = async () => {
    if (document instanceof HTMLDocument) {
        const frameUrl = window.location.href;
        if (frameUrl && frameUrl.indexOf('http') === 0) {
            // TODO: Pass logging level via storage from the background page / native host
            const ENABLE_DEBUG_LOGGING = false;
            if (ENABLE_DEBUG_LOGGING) {
                log.setLevelDebug();
            }

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

            const selectorsAndScripts = prepareAdvancedRules(cosmeticResult, frameUrl, ENABLE_DEBUG_LOGGING);

            applyAdvancedRules(selectorsAndScripts, frameUrl);
        }
    }
};

export const content = {
    init,
};
