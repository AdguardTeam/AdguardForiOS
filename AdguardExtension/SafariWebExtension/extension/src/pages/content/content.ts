import browser from 'webextension-polyfill';

import { getAdvancedRulesText } from './advanced-rules/get';
import { applyAdvancedRules } from './advanced-rules/apply';

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
        // eslint-disable-next-line no-console
        console.log(`Could not wake up background page due to: ${e}`);
    }
};

const init = async () => {
    if (document instanceof HTMLDocument) {
        if (window.location.href && window.location.href.indexOf('http') === 0) {
            /**
             * Wake background page to force the advanced rules update from native host.
             *
             * IMPORTANT: it should not be 'await wakeBackgroundPage()'
             * because it will postpone the execution of the following code and it is not needed.
             * We need to apply the rules as soon as possible.
             */
            wakeBackgroundPage();

            const rulesText = await getAdvancedRulesText();
            if (!rulesText) {
                return;
            }

            applyAdvancedRules(window.location.href, rulesText);
        }
    }
};

export const content = {
    init,
};
